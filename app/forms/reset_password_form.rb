# frozen_string_literal: true

class ResetPasswordForm < Reform::Form
  property :password
  property :password_confirmation
  property :reset_token_expires_at

  validates :password,
    confirmation: true,
    length: { minimum: ENV['PASSWORD_MIN_LENGTH'].to_i }
  validate :expires_at_cannot_be_in_the_past

  def expires_at_cannot_be_in_the_past
    if reset_token_expires_at < Time.current
      errors.add(:base, "Reset link has already expired")
    end
  end
end
