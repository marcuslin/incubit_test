# frozen_string_literal: true

class UpdateUserForm < Reform::Form
  property :email
  property :username
  property :password
  property :password_confirmation

  validates :username,
    length: { minimum: ENV['USERNAME_MIN_LENGTH'].to_i }
  validates :password,
    confirmation: true,
    length: { minimum: ENV['PASSWORD_MIN_LENGTH'].to_i }
end
