# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    address_line_1 { Faker::Address.street_address }
    address_line_2 { Faker::Address.secondary_address  }
    city { Faker::Address.city }
    state { Faker::Address.state }
    pincode { %w[560007 560001 560025 560092 560300].sample }
    country { 'India' }
    user
  end
end
