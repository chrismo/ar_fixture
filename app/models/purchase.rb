class Purchase < ActiveRecord::Base
  belongs_to :customer
  has_one :address
  has_one :collection

  connection.create_table table_name, :force => true do |t|
    t.integer 'customer_id', :null => false
    t.string 'external_record_type', :null => false
    t.string 'external_id', :null => false
    t.string 'title', :null => false
    t.decimal 'price', :precision => 8, :scale => 2, :null => false
    t.string 'currency', :null => false
    t.integer 'quantity', :null => false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end
end
