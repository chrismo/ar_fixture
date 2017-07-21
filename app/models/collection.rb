class Collection < ActiveRecord::Base
  belongs_to :purchase

  connection.create_table table_name, :force => true do |t|
    t.integer 'purchase_id', :null => false
    t.string 'awb'
    t.string 'status'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.datetime 'exported_at'
    t.datetime 'canceled_at'
    t.string 'last_status_description'
    t.datetime 'last_claimed_at'
    t.datetime 'last_attempted_at'
  end

  END_STATES = %w(collected canceled refused)

  scope :problem_old_exports, lambda { where('exported_at < ? AND status NOT IN (?)', 3.days.ago, END_STATES) }

  state_machine :status, :initial => lambda { |collection| collection.customer.new? ? :received : :customer_verified } do
    state :received
    state :customer_verified
    state :exported
    state :delivered
    state :collected
    state :canceled
    state :refused

    event :export do
      transition :customer_verified => :exported
    end
    event :cancel do
      transition all - [:refused, :collected] => :canceled
    end
    event :refuse do
      transition all - [:canceled, :delivered, :collected] => :refused
    end
    event :deliver do
      transition all - [:canceled, :refused, :collected] => :delivered
    end
    event :collect do
      transition all - [:canceled, :refused] => :collected
    end

    after_transition :received => :customer_verified do |collection, transition|
      collection.customer.verify! if collection.customer.status_name == :new
    end

    after_transition any => :collected do |collection, transition|
      collection.customer.collect! unless collection.customer.status_name == :collected
    end

    after_transition any => :exported do |collection, transition|
      collection.update_attribute(:exported_at, Time.now)
    end

    after_transition any => :canceled do |collection, transition|
      collection.update_attribute(:canceled_at, Time.now)
    end

  end

  def self.status_values
    state_machines[:status].states.map(&:name)
  end

  self.status_values.each do |status|
    scope status, lambda { with_status(status) }
  end

  def customer
    purchase.customer
  end

  def address
    purchase.address
  end

  def status_index
    self.class.status_values.index(status_name)
  end

  def purchase_time
    purchase.created_at
  end

  def claim
    update_attribute(:last_claimed_at, Time.now)
  end

  def self.problem_named_scopes
    self.methods.grep(/^problem_/).collect { |n| n.to_s.sub(/^problem_/, '') }.delete_if { |n| n == 'named_scopes' }
  end
end
