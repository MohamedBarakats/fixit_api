# frozen_string_literal: true

require "rails_helper"

RSpec.describe Order, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end
