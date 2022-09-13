FactoryBot.define do
  factory :plan do
    sequence(:id)
    name { Faker::Name.unique.name }
    monthly_fee { 500 }

  end
end
