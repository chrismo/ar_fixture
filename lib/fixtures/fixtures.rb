require 'faker'

class BaseFixture
  def self.build(params = {})
    self.new(params)
  end

  def self.create(params = {})
    self.new(params).tap(&:save!)
  end

  def self.opts
    @opts ||= {}
  end

  def self.merge_opts(defaults, opts)
    defaults.merge(self.opts).merge(opts).tap do
      # reset these to prevent accidental reuse on future fixtures
      @opts = nil
    end
  end
end

class AddressFixture < BaseFixture
  def self.new(opts={})
    Address.new({:name => Faker::Name.name}.merge(opts))
  end
end

class CustomerFixture < BaseFixture
  @@customer_id = Customer.last.external_id + 1 rescue 1

  def self.new(opts={})
    Customer.new({:external_record_type => 'person',
                  :external_id => @@customer_id += 1,
                  :email => Faker::Internet.email}.merge(opts))
  end
end

class PurchaseFixture < BaseFixture
  @@purchase_id = Purchase.last.external_id + 1 rescue 1

  def self.new(opts={})
    customer = CustomerFixture.new
    Purchase.new({:currency => 'USD', 
                  :external_record_type => 'purchase',
                  :external_id => @@purchase_id += 1,
                  :price => rand(50) + 1,
                  :quantity => rand(4) + 1,
                  :title => Faker::Company.catch_phrase,
                  :address => AddressFixture.new(:customer => customer),
                  :customer => customer}.merge(opts))
  end
end

class CollectionFixture < BaseFixture
  def self.new(opts={})
    Collection.new({:purchase => PurchaseFixture.new}.merge(opts))
  end
end
