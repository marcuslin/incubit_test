# frozen_string_literal: true

class ResetPasswordMailer < ApplicationMailer
  def reset_password_instruction(user)
    @token = user.reset_password_token

    mail_info = {
      to: user.email,
      cc: nil,
      subject: 'Reset password instruction'
    }

    mail(mail_info)
  end
end
