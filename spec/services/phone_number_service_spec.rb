# frozen_string_literal: true

require "rails_helper"

RSpec.describe PhoneNumberService, type: :service do
  describe "#initialize" do
    context "when number keys is missing" do
      it "raises MissingArguments error " do
        expect { described_class.new }
          .to raise_error(ArgumentError, /missing keyword: :number/)
      end
    end
    context "when number key is present" do
      it "returns an_instance_of  UserService" do
        expect(described_class.new(number: nil)).to be_an_instance_of(described_class)
      end
    end
  end

  describe "#create" do
    context "when params are correct but user is missing" do
      subject { described_class.new(number: "+49 015 2052 90170") }
      it "returns User must exist" do
        _phone_number_object, errors = subject.create
        expect(errors).to include("User must exist")
      end
    end

    context "when user exists" do
      let(:user) { create(:user) }
      subject { described_class.new(number: "+49 015 2052 90170", user_id: user.id) }
      it "returns phone_number_object" do
        phone_number_object, _errors = subject.create
        expect(phone_number_object[:phone_number][:data][:attributes])
          .to eq({ number: "+49 015 2052 90170", user_id:  user.id })
      end
    end

    context "when phone number is not valid" do
      context "with user exists" do
        let(:user) { create(:user) }
        subject { described_class.new(number: "+201002216385", user_id: user.id) }
        it "does not create a phone number" do
          expect { subject.create }.not_to change { PhoneNumber.count }.from(0)
          _phone_number_object, errors = subject.create
          expect(errors).to  eq(["Number is invalid"])
        end
      end

      context "without user exists" do
        subject { described_class.new(number: "+201002216385", user_id: nil) }
        it "does not create a phone number" do
          expect { subject.create }.not_to change { PhoneNumber.count }.from(0)
          _phone_number_object, errors = subject.create
          expect(errors).to eq(["User must exist", "Number is invalid"])
        end
      end
    end
  end
end
