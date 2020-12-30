# frozen_string_literal: true

class UserService
  include Response
  attr_reader :user_params

  def create(user_params:)
    return unless user_params

    @user_params = user_params
    @errors = []
    response = {}
    ActiveRecord::Base.transaction do
      user = create_user(user_params: user_params)
      response = user_response(user: user) if @errors.empty?
      raise ActiveRecord::Rollback if @errors.any?
    end
    [response, @errors]
  end

  private

    def create_user(user_params:)
      user = User.create(user_params.except(:mobile_number))
      @errors += user.errors.full_messages
      create_associations(user_id: user.id)
      user
    end

    def user_response(user:)
      auth_token = AuthenticateUser.new(email: user.email, password: user.password).call
      { message: JsonWebTokenMessages.account_created, auth_token: auth_token,
        user: user_serialized_object(user: user) }
    end

    def user_serialized_object(user:)
      generic_serialized_object(object: user, serializer: 'UserSerializer', includes: [:phone_numbers])
    end

    def create_associations(user_id:)
      create_phone_number(
        number: user_params[:mobile_number],
        user_id: user_id
      )
    end

    def create_phone_number(number:, user_id:)
      phone_number_params = { number: number, user_id: user_id }
      _response, errors = PhoneNumberService.new.create(phone_number_params: phone_number_params)
      @errors += errors
    end
end
