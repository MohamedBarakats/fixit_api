# frozen_string_literal: true

class OrderSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :note
end
