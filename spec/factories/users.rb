# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password(10, 20) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    mobile_number { [7, 8, 9].sample.to_s + Faker::Number.number(9) }
    username { Faker::Internet.user_name(Faker::Internet.user_name(4..40), '_') }
  end
end
