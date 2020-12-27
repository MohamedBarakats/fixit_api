# frozen_string_literal: true

class PhoneNumber < ApplicationRecord
  belongs_to :user
  validates :number, presence: true, uniqueness: true,
                     phone: { possible: true, allow_blank: false, types: [:fixed_or_mobile], countries: [:de] }
end
