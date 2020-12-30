# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderService, type: :service do
  let(:valid_attributes) do
    attributes_for(:order)
  end
  describe "#initialize" do
    context "when order keys is missing" do
      it "raises MissingArguments error " do
        expect { described_class.new }
          .to raise_error(ArgumentError, /missing keyword: :order/)
      end
    end
    context "when order key is present" do
      it "returns an_instance_of  UserService" do
        expect(described_class.new(order: {})).to be_an_instance_of(described_class)
      end
    end
  end

  describe "#create" do
    context "when params are correct but user is missing" do
      subject { described_class.new(order: valid_attributes) }
      it "returns User must exist" do
        _order_object, errors = subject.create
        expect(errors).to include("User must exist")
      end
    end

    context "when user exists" do
      let(:user) { create(:user) }
      subject { described_class.new(order: valid_attributes, user_id: user.id) }
      it "returns order_object" do
        order_object, _errors = subject.create
        expect(order_object[:order][:data][:attributes])
          .to eq({ title: "Fixing TV", description: "stopped suddenly", note: "it's not German TV" })
      end
    end

    context "when  order is not valid" do
      context "with user exists" do
        let(:user) { create(:user) }
        subject { described_class.new(order: { note: "just a note" }, user_id: user.id) }
        it "does not create an order" do
          expect { subject.create }.not_to change { Order.count }.from(0)
          _order_object, errors = subject.create
          expect(errors).to  eq(["Title can't be blank", "Description can't be blank"])
        end
      end

      context "without user exists" do
        subject { described_class.new(order: { note: "just a note" }, user_id: nil) }
        it "does not create an order" do
          expect { subject.create }.not_to change { Order.count }.from(0)
          _order_object, errors = subject.create
          expect(errors).to eq(["Title can't be blank", "Description can't be blank", "User must exist"])
        end
      end
    end
  end
end
