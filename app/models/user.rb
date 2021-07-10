# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  before_create :assign_username

  private

  def assign_username
    self.username = email.split('@').first
  end
end
