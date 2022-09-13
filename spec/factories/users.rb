FactoryBot.define do
  factory :user do
    sequence(:id)
    name { Faker::Name.unique.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
    avatar {fixture_file_upload(Rails.root.join('spec/fixtures/dp3.png'))}
  end

  trait :Buyer do
    usertype { 'Buyer' }
  end

  trait :admin do
    usertype { 'Admin' }
  end

  trait :invalid_avatar do
    avatar {fixture_file_upload(Rails.root.join('spec/fixtures/Alchemist.webp'), 'image/webp')}
  end

end
