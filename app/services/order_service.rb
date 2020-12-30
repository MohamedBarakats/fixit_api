# frozen_string_literal: true

class OrderService
  include Response
  attr_reader :order_params

  def initialize(order:, user_id: nil)
    @order_params = order.merge!({ user_id: user_id })
  end

  def create
    @errors = []
    response = {}
    ActiveRecord::Base.transaction do
      order = create_order(order_params: order_params)
      response = { order: order_serialized_object(order: order) } if @errors.empty?
      raise ActiveRecord::Rollback if @errors.any?
    end
    [response, @errors]
  end

  private

    def order_serialized_object(order:)
      generic_serialized_object(object: order, serializer: 'OrderSerializer')
    end

    def create_order(order_params:)
      order = Order.create(order_params)
      @errors += order.errors.full_messages
      order
    end
end
