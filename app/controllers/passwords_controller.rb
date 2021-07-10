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
  end

  private

  def user_params
    params[:user]
  end
end
