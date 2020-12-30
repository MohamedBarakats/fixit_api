# frozen_string_literal: true

class PhoneNumberService
  include Response
  def create(phone_number_params:)
    @errors = []
    response = {}
    phone_number = PhoneNumber.find_or_create_by(phone_number_params)
    @errors += phone_number.errors.full_messages
    if @errors.empty?
      response = {
        phone_number: phone_number_serialized_object(phone_number: phone_number)
      }
    end
    [response, @errors]
  end

  private

    def phone_number_serialized_object(phone_number:)
      generic_serialized_object(object: phone_number, serializer: 'PhoneNumberSerializer')
    end
end
