# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    sequence(:id)
    name { Faker::Name.unique.name }
    monthly_fee { 500 }
  end

  trait :blank_plan_name do
    name { nil }
  end

  trait :blank_plan_monthly_fee do
    monthly_fee { nil }
  end

  trait :less_than_zero_monthly_fee do
    monthly_fee { -1 }
  end
end
