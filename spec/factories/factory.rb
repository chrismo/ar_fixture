FactoryGirl.define do
  factory :customer do
    external_record_type 'person'
    sequence(:external_id)
    email Faker::Internet.email
  end

  factory :address do
    name Faker::Name.name
    customer
  end

  sequence :purchase_external_id
  sequence :purchase_deal_id

  factory :purchase do
    currency 'USD'
    external_record_type 'purchase'
    external_id { FactoryGirl.generate(:purchase_external_id) }
    price { rand(50) + 1 }
    customer
    association :address, :method => :build
    quantity { rand(4) + 1 }
    title Faker::Company.catch_phrase
  end

  factory :collection do
    # YOU HAD ONE JOB
    purchase # this comes too late to satisfy the state_machine initialize code
  end
end
