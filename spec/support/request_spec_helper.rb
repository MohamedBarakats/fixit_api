# frozen_string_literal: true

module RequestSpecHelper
  include Response
  def json
    JSON.parse(response.body).with_indifferent_access
  end

  def serialized_object_to_json(object:)
    JSON.parse(object.to_json).with_indifferent_access
  end
end
