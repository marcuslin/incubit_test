# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  def send_welcome_mail(user)
    @user = user

    mail_info = {
      to: @user.email,
      cc: nil,
      subject: 'Welcome'
    }

    mail(mail_info)
  end
end
