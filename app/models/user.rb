# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates_presence_of :first_name, :last_name, :email, :password_digest
  validates_uniqueness_of :email
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8, maximum: 64 }
end
