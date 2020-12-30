# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user { create(:user) }
    title { "Fixing TV" }
    note { "it's not German TV" }
    description { "stopped suddenly" }
  end
end
