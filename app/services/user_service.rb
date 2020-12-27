# frozen_string_literal: true

class UserService
  attr_reader :user_params

  def initialize(user_params:)
    @user_params = user_params
  end

  def create
    @errors = []
    response = {}
    ActiveRecord::Base.transaction do
      user = create_user(user_params: user_params.except(:mobile_number))
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
      UserSerializer.new(user, include: [:phone_numbers]).serializable_hash
    end

    def create_associations(user_id:)
      create_phone_number(
        number: user_params[:mobile_number],
        user_id: user_id
      )
    end

    def create_phone_number(number:, user_id:)
      _response, errors = PhoneNumberService.new(number: number, user_id: user_id).create
      @errors += errors
    end
end
