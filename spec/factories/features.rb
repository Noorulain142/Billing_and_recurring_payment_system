FactoryBot.define do
  factory :feature do
    name { Faker::Name.unique.name }
    code { 1 }
    unit_price { 1 }
    max_unit_limit { 5 }
    usage_value { 6 }
    over_use { 0 }
    plan
  end
end
