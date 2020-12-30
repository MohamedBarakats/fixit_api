# frozen_string_literal: true

class Order < ApplicationRecord
  validates_presence_of :title, :description
  belongs_to :user
end
