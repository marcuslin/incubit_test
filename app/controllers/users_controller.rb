# frozen_string_literal: true

class UsersController < ApplicationController
  def edit
    @form = UpdateUserForm.new(User.find_by(id: params[:id]))
  end
end
