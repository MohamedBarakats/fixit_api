# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "foobar@123Berlin" }
    gender { "male" }

    trait :with_mobile_number do
      phone_numbers { create_list :phone_number, 1 }
    end
  end
end
