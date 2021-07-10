# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
    @form = RegistrationForm.new(User.new)
  end
end
