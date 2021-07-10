# frozen_string_literal: true

class PasswordsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: user_params[:email])

    flash[:notice] = 'Reset password token sent'

    Passwords::GenerateResetToken.call(@user)

    redirect_back(fallback_location: root_path)
  end

  def edit
  end

  def update
    @form = ResetPasswordForm.new(User.find_by(reset_password_token: params[:reset_password_token]))

    if @form.validate(user_params)
      @form.save

      redirect_to root_path, notice: 'Password changed'
    else
      flash[:error] = @form.errors.full_messages

      redirect_back(fallback_location: root_path)
    end
  end

  private

  def user_params
    params[:user]
  end
end
