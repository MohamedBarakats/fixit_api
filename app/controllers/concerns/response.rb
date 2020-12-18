# frozen_string_literal: true

# app/controllers/concerns/response.rb
module Response
  def json_response(response:, status: :ok)
    render json: response, status: status
  end
end
