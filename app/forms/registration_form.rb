# frozen_string_literal: true

class RegistrationForm < Reform::Form
  property :email
  property :password
  property :password_confirmation

  validates_uniqueness_of :email
  validates :email,
    presence: true,
    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,
              message: 'Invalid format' }
  validates :password,
    confirmation: true,
    length: { minimum: ENV['PASSWORD_MIN_LENGTH'].to_i }
end
