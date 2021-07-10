# frozen_string_literal: true

require 'rails_helper'

describe 'Reset Password', type: :feature do
  let(:unexpired_user) { create(:user_with_unexpired_reset_token) }
  let(:expired_user) { create(:user_with_expired_reset_token) }
  let(:valid_password) { Faker::Internet.password(min_length: ENV['PASSWORD_MIN_LENGTH'].to_i) }
  let(:unmatched_confirmation) { Faker::Internet.password(min_length: ENV['PASSWORD_MIN_LENGTH'].to_i) }
  let(:invalid_password) { Faker::Internet.password(min_length: 1, max_length: ENV['PASSWORD_MIN_LENGTH'].to_i - 1) }

  context 'with unexpired user' do
    before do
      visit edit_password_path(unexpired_user.reset_password_token)
    end

    scenario 'reset with valid password' do
      fill_in 'user_password', with: valid_password
      fill_in 'user_password_confirmation', with: valid_password

      click_on 'reset password'

      expect(current_path).to eq root_path
      expect(page).to have_field 'Email'
      expect(page).to have_field 'Password'
      expect(page).to have_button 'Sign In'
      expect(page).to have_content 'Password changed'
    end

    scenario 'reset with invalid password' do
      fill_in 'user_password', with: invalid_password
      fill_in 'user_password_confirmation', with: invalid_password

      click_on 'reset password'

      expect(current_path).to eq edit_password_path(unexpired_user.reset_password_token)
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
      expect(page).to have_button 'reset password'
      expect(page).not_to have_content 'Password changed'
      expect(page).to have_content 'Password is too short (minimum is 8 characters)'
    end

    scenario 'reset with unmatched confirmation' do
      fill_in 'user_password', with: valid_password
      fill_in 'user_password_confirmation', with: unmatched_confirmation

      click_on 'reset password'

      expect(current_path).to eq edit_password_path(unexpired_user.reset_password_token)
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
      expect(page).to have_button 'reset password'
      expect(page).not_to have_content 'Password changed'
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  context 'with expired user' do
    before do
      visit edit_password_path(expired_user.reset_password_token)
    end

    scenario 'reset with valid password' do
      fill_in 'user_password', with: valid_password
      fill_in 'user_password_confirmation', with: valid_password

      click_on 'reset password'

      expect(current_path).to eq edit_password_path(expired_user.reset_password_token)
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
      expect(page).to have_button 'reset password'
      expect(page).not_to have_content 'Password changed'
      expect(page).to have_content 'Reset link has already expired'
    end

    scenario 'reset with invalid password' do
      fill_in 'user_password', with: invalid_password
      fill_in 'user_password_confirmation', with: invalid_password

      click_on 'reset password'

      expect(current_path).to eq edit_password_path(expired_user.reset_password_token)
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
      expect(page).to have_button 'reset password'
      expect(page).not_to have_content 'Password changed'
      expect(page).to have_content 'Password is too short (minimum is 8 characters)'
      expect(page).to have_content 'Reset link has already expired'
    end

    scenario 'reset with unmatched confirmation' do
      fill_in 'user_password', with: valid_password
      fill_in 'user_password_confirmation', with: unmatched_confirmation

      click_on 'reset password'

      expect(current_path).to eq edit_password_path(expired_user.reset_password_token)
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
      expect(page).to have_button 'reset password'
      expect(page).not_to have_content 'Password changed'
      expect(page).to have_content "Password confirmation doesn't match Password"
      expect(page).to have_content 'Reset link has already expired'
    end
  end
end
