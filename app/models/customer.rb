class Customer < ActiveRecord::Base
  has_many :addresses
  has_many :purchases

  connection.create_table table_name, :force => true do |t|
    t.string 'external_record_type', :null => false
    t.string 'external_id', :null => false
    t.string 'email', :null => false
    t.string 'status'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  scope :not_yet_verified, lambda { where(:status => 'new') }

  state_machine :status, :initial => :new do
    state :new
    state :verified
    state :collected

    event(:verify) { transition :new => :verified }
    event(:collect) { transition all => :collected }
  end
end
