# frozen_string_literal: true

class Currencies < ClassyEnum::Base
  def to_s
    code
  end
end

class Currencies
  class Euro < Currencies
    def code
      :eur
    end

    def symbol
      '€'
    end
  end
end
