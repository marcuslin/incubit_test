# frozen_string_literal: true

module Passwords
  class GenerateResetToken
    include Serviceable

    def initialize(user)
      @user = user
      @reset_password_token = SecureRandom.hex(16)
      @reset_token_expires_at = ENV['VALID_RESET_TOKEN_DURATION'].to_i.hours.since
    end

    def call
      return unless user

      user.update(reset_password_token: reset_password_token,
                  reset_token_expires_at: reset_token_expires_at)

      ResetPasswordMailer.reset_password_instruction(user).deliver_now
    end

    private

    attr_accessor :user, :user_params, :reset_password_token,
      :reset_token_expires_at
  end
end
