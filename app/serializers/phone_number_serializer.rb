# frozen_string_literal: true

class PhoneNumberSerializer
  include JSONAPI::Serializer
  attributes :number, :user_id
end
