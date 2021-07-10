# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :check_edit_permission

  def edit
    form
  end

  def update
    if form.validate(params[:user])
      flash[:notice] = 'Updated successfully'

      form.save
    else
      flash[:error] = form.errors.full_messages
    end

    redirect_to edit_user_path(form.model)
  end

  private

  def form
    @form ||= UpdateUserForm.new(User.find_by(id: params[:id]))
  end

  def check_edit_permission
    if current_user != form.model
      flash[:error] = 'You are not allowed to perform this action'

      redirect_back(fallback_location: root_path)
    end
  end
end
