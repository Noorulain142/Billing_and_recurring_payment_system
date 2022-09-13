# frozen_string_literal: true

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

  trait :blank_feature_name do
    name { nil }
  end

  trait :blank_feature_code do
    code { nil }
  end

  trait :blank_feature_unit_price do
    unit_price { nil }
  end

  trait :blank_feature_max_unit_limit do
    max_unit_limit { nil }
  end

  trait :blank_feature_usage_value do
    usage_value { nil }
  end

  trait :less_than_zero_feature_usage_value do
    usage_value { -1 }
  end

  trait :less_than_zero_feature_max_unit_limit do
    max_unit_limit { -1 }
  end

  trait :less_than_zero_feature_unit_price do
    unit_price { -1 }
  end

  trait :less_than_zero_feature_code do
    code { -1 }
  end
end
