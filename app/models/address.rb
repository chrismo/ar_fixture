class Address < ActiveRecord::Base
  belongs_to :customer
  belongs_to :purchase

  connection.create_table table_name, :force => true do |t|
    t.integer 'customer_id', :null => false
    t.integer 'purchase_id', :null => false
    t.string 'street_address_1'
    t.string 'street_address_2'
    t.string 'city'
    t.string 'country'
    t.string 'phone'
    t.text 'delivery_notes'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'name', :null => false
  end
end
