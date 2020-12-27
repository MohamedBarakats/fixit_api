# frozen_string_literal: true

FactoryBot.define do
  factory :phone_number do
    user { build(:user) }
    number { "+49 015 2052 90170" }
  end
end
