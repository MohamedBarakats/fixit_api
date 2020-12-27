# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :email, :gender
  has_many :phone_numbers
end
