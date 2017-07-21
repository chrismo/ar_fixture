require 'machinist/active_record'
require 'faker'

Sham.sham_id { |i| i }

Customer.blueprint do
  external_record_type { 'person' }
  external_id { Sham.sham_id }
  email { Faker::Internet.email }
end

Address.blueprint do
  name Faker::Name.name
  customer
  purchase
end

Purchase.blueprint do
  currency {'USD'}
  external_record_type {'purchase'}
  external_id { Sham.sham_id }
  deal_id { Sham.sham_id }
  price { rand(50) + 1 }
  customer
  quantity { rand(4) + 1 }
  title { Faker::Company.catch_phrase }
end

Collection.blueprint do
  purchase
end