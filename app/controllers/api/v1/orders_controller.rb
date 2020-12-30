# frozen_string_literal: true

module Api
  module V1
    class OrdersController < ApplicationController
      before_action :set_order, only: %i[show update destroy]

      # GET /orders
      def index
        @orders = Order.all
        json_response(response: { orders: @orders }, status: :ok)
      end

      # GET /orders/1
      def show
        json_response(response: { order: order_serialized_object(order: @order) }, status: :ok)
      end

      # POST /orders
      def create
        order_object, errors = OrderService.new.create(order_params: order_params.merge!({ user_id: current_user.id }))
        if errors.empty?
          json_response(response: order_object, status: :created)
        else
          render_errors(errors: errors, status: :unprocessable_entity)
        end
      end

      # PATCH/PUT /orders/1
      def update
        order_object, errors = OrderService.new.update(order: @order, order_params: order_params)
        if errors.empty?
          json_response(response: order_object, status: :ok)
        else
          render_errors(errors: errors, status: :unprocessable_entity)
        end
      end

      # DELETE /orders/1
      def destroy
        @order.destroy
      end

      private

        def set_order
          @order = Order.find(params[:id])
        end

        def order_params
          params.require(:order).permit(:title, :note, :description)
        end

        def order_serialized_object(order:)
          OrderSerializer.new(order).serializable_hash
        end
    end
  end
end
