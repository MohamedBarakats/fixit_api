# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserService, type: :service do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password, mobile_number: "+49015205290170")
  end
  let(:invalid_attributes) do
    {
      first_name: nil,
      last_name: nil,
      email: nil,
      password: nil,
      password_confirmation: nil,
      gender: nil
    }
  end
  describe "#create" do
    context "when user_params key is missing" do
      it "raises MissingArguments error " do
        expect { described_class.new.create }
          .to raise_error(ArgumentError, /missing keyword: :user_params/)
      end
    end

    context "when user_params key is present but nil" do
      it "returns false" do
        expect(described_class.new.create(user_params: nil)).to be_falsy
      end
    end

    context "when params are correct" do
      subject { described_class.new.create(user_params: valid_attributes) }
      it "returns the user data" do
        user_object, _errors = subject
        expect(user_object[:user][:data][:attributes][:last_name]).to eq(valid_attributes[:last_name])
      end
    end

    context "when user exists" do
      subject { described_class.new.create(user_params: valid_attributes.merge!({ email: user.email })) }
      it "returns failure message for Email has already been taken" do
        _user_object, errors = subject
        expect(errors)
          .to include("Email has already been taken")
      end
    end

    context "when email or any param is not valid" do
      subject { described_class.new.create(user_params: invalid_attributes) }

      it "does not create a user" do
        expect { subject }.not_to change { User.count }.from(0)
      end

      it "returns error message for Email has already been taken" do
        _user_object, errors = subject
        expect(errors)
          .to include("Email is invalid")
      end
    end
  end
end
