# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :phone_numbers, dependent: :destroy
  has_many :orders, dependent: :destroy

  enum gender: {
    male: 'male',
    female: 'female',
    other: 'other',
    prefer_not_to_disclose: 'prefer_not_to_disclose'
  }
  validates_presence_of :first_name, :last_name, :email, :password_digest, :gender
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8, maximum: 64 }
end
