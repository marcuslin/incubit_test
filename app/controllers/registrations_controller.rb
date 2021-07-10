# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
    @form = RegistrationForm.new(User.new)
  end

  def create
    @form = RegistrationForm.new(User.new)

    if @form.validate(params[:user])
      @form.save
      user = @form.sync

      WelcomeMailer.send_welcome_mail(user).deliver_now

      sign_in(user, 'Sign up successfully')
    else
      flash[:error] = @form.errors.full_messages

      render(:new)
    end
  end
end
