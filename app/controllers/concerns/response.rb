# frozen_string_literal: true

# app/controllers/concerns/response.rb
module Response
  def json_response(response:, status: :ok)
    render json: response, status: status
  end

  def render_errors(errors:, status: :unprocessable_entity)
    render json: { errors: errors }, status: status
  end

  def generic_serialized_object(object:, serializer:, includes: [])
    serializer.constantize.new(object, include: includes).serializable_hash
  end
end
