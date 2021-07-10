class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user])
  end

  def sign_in(user, notification_message = 'Signed in')
    session[:user] = user.id

    redirect_to edit_user_path(user), notice: notification_message
  end
end
