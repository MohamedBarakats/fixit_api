# frozen_string_literal: true

class OrderService
  include Response

  def create(order_params:)
    @errors = []
    response = {}
    ActiveRecord::Base.transaction do
      order = create_order(order_params: order_params)
      response = { order: order_serialized_object(order: order) } if @errors.empty?
      raise ActiveRecord::Rollback if @errors.any?
    end
    [response, @errors]
  end

  def update(order:, order_params:)
    return 'order is not an ActiveRecord Object' unless order.is_a?(ActiveRecord::Base)

    @errors = []
    response = {}
    ActiveRecord::Base.transaction do
      order = update_order(order: order, order_params: order_params)
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

    def update_order(order:, order_params:)
      order.update(order_params)
      @errors += order.errors.full_messages
      order
    end
end
