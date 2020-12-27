# frozen_string_literal: true

class CountryEnum < ClassyEnum::Base
  def to_s
    code
  end

  def config
    {}
  end

  def code
    config[:code]
  end

  def vat
    config[:vat]
  end

  def vat_for_invoice?
    config[:vat_for_invoice]
  end

  def currency
    config[:currency]
  end

  def phone_country_code
    config[:phone_country_code]
  end

  def self.country_code
    new.config[:phone_country_code]
  end

  def phone_mobile_codes
    config[:phone_mobile_codes]
  end

  def vat_display
    ((vat - 1) * 100)
  end
end

class CountryEnum
  class Germany < CountryEnum
    def config
      {
        code: 'DE',
        currency: Currencies::Euro.new,
        phone_country_code: '49',
        phone_mobile_codes: %w[151 160 170 171 175 152 162 172 173 174 157 163
                               177 178 159 176 179 161 164],
        vat: vat,
        vat_for_invoice: true
      }
    end

    def vat
      if (Date.parse('2020-07-01')..Date.parse('2020-12-31')).cover?(Time.current.to_date)
        1.16
      else
        1.19
      end
    end

    def aliases
      %w[deutschland de]
    end
  end
end
