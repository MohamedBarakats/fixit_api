# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users API", type: :request do
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except("Authorization") }
  let(:invalid_headers_param) { invalid_headers }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end
  let(:invalid_attributes) do
    {
      name: nil,
      email: nil,
      password: nil,
      password_confirmation: nil
    }
  end

  describe "POST /signup" do
    context "when valid request" do
      before { post "/signup", params: { user: valid_attributes }.to_json, headers: headers }

      it "creates a new user" do
        expect(response).to have_http_status(201)
      end

      it "returns success message" do
        expect(json["message"]).to match(/Account created successfully/)
      end

      it "returns an authentication token" do
        expect(json["auth_token"]).not_to be_nil
      end
    end

    context "when invalid params" do
      before { post "/signup", params: { user: invalid_attributes }.to_json, headers: headers }

      it "does not create a new user" do
        expect(response).to have_http_status(422)
      end

      it "returns failure message" do
        expect(json["message"])
          .to include("Validation failed:")
      end
    end

    context "when missing params" do
      it "raises ParameterMissing" do
        expect do
          post "/signup", params: { user: nil }.to_json,
                          headers: headers
        end.to raise_error(ActionController::ParameterMissing,
                           /param is missing or the value is empty: use/)
      end
    end

    context "when invalid_headers" do
      before { post "/signup", params: { user: invalid_attributes }.to_json, headers: invalid_headers_param }

      it "returns 422" do
        expect(response).to have_http_status(422)
      end
    end
  end
end
