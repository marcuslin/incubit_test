# frozen_string_literal: true

module Sessions
  class AuthenticateUser
    include Serviceable

    def initialize(user, user_params)
      @user = user
      @password = user_params[:password]
    end

    def call
      itself
    end

    def authorized?
      user&.authenticate(password) && !user&.locked?
    end

    def error_message
      if !user&.authenticate(password)
        error_messages[:incorrect_info]
      elsif user&.locked?
        error_messages[:locked]
      end
    end

    private

    attr_reader :user, :password

    def error_messages
      {
        locked: 'This account has been locked, please contact administrator for unlocking account',
        incorrect_info: 'The email or password you entered is incorrect'
      }
    end
  end
end
