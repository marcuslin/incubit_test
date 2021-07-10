# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    redirect_to edit_user_path(current_user.id) if current_user
  end

  def create
    @user = User.find_by(email: params[:user][:email])
    user_authentication = Sessions::AuthenticateUser.call(@user, params[:user])

    if user_authentication.authorized?
      sign_in(@user)
    else
      flash[:error] = user_authentication.error_message

      Sessions::LockUser.call(@user) if @user

      render(:new)
    end
  end

  def destroy
    session[:user] = nil if current_user

    redirect_to root_path
  end
end
