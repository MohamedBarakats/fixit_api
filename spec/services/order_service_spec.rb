# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderService, type: :service do
  let(:valid_attributes) do
    attributes_for(:order)
  end

  describe "#create" do
    context "when params are correct but user is missing" do
      subject { described_class.new.create(order_params: valid_attributes.merge!({ user_id: nil })) }
      it "returns User must exist" do
        _order_object, errors = subject
        expect(errors).to include("User must exist")
      end
    end

    context "when user exists" do
      let(:user) { create(:user) }
      subject { described_class.new.create(order_params: valid_attributes.merge!({ user_id: user.id })) }
      it "returns order_object" do
        order_object, _errors = subject
        expect(order_object[:order][:data][:attributes])
          .to eq({ title: "Fixing TV", description: "stopped suddenly", note: "it's not German TV" })
      end
    end

    context "when  order is not valid" do
      context "with user exists" do
        let(:user) { create(:user) }
        subject { described_class.new.create(order_params: { note: "just a note", user_id: user.id }) }
        it "does not create an order" do
          expect { subject }.not_to change { Order.count }.from(0)
          _order_object, errors = subject
          expect(errors).to eq(["Title can't be blank", "Description can't be blank"])
        end
      end

      context "without user exists" do
        subject { described_class.new.create(order_params: { note: "just a note", user_id: nil }) }
        it "does not create an order" do
          expect { subject }.not_to change { Order.count }.from(0)
          _order_object, errors = subject
          expect(errors).to eq(["Title can't be blank", "Description can't be blank", "User must exist"])
        end
      end
    end
  end

  describe "#update" do
    context "when params are correct but order is missing" do
      subject { described_class.new.update(order: "FakeOrder", order_params: valid_attributes) }
      it "returns error when order.update" do
        expect(subject).to eq("order is not an ActiveRecord Object")
      end
    end

    context "when order exists" do
      let(:order) { create(:order) }
      subject { described_class.new.update(order: order, order_params: { description: "Update works fine" }) }
      it "update success and returns order_object" do
        order_object, _errors = subject
        expect(order_object[:order][:data][:attributes][:description]).to eq("Update works fine")
      end
    end

    context "when  params are  not valid" do
      context "with order exists" do
        let(:order) { create(:order) }
        subject { described_class.new.update(order: order, order_params: { description: nil }) }
        it "returns erros and does not update the order" do
          _order_object, errors = subject
          expect(errors).to eq(["Description can't be blank"])
        end
      end
    end
  end
end
