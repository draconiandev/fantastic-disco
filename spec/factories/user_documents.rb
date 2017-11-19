# frozen_string_literal: true

FactoryBot.define do
  factory :user_document do
    num_between_1to9 = Faker::Number.between(1, 9).to_s
    num = ('a'..'p').to_a.sample + num_between_1to9 + Faker::Number.number(5).to_s + num_between_1to9
    passport_number { num }
    passport 'MyString'
    pan_number { ('a'..'z').sort_by { rand }[0, 5].join + Faker::Number.number(4).to_s + ('a'..'z').to_a.sample }
    pan 'MyString'
    aadhar_number { Faker::Number.number(12) }
    aadhar 'MyString'
    user
  end
end
