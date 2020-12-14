# frozen_string_literal: true

require "rails_helper"

RSpec.describe JsonWebToken do
  describe "#encode" do
    it "generates a new token with the given payload" do
      token = described_class.encode(payload: { name: "Mohamed" })
      expect(token).not_to be_nil
    end
  end

  describe "#decode" do
    it "decodes a valid token" do
      token = described_class.encode(payload: { name: "Mohamed" })
      data = described_class.decode(token: token)
      expect(data[:name]).to eq("Mohamed")
    end

    it "raises ExceptionHandler::InvalidToken if the token is invalid" do
      expect { described_class.decode(token: "invalidtoken.invalid.invalid") }
        .to raise_error(ExceptionHandler::InvalidToken)
    end
  end
end
