# frozen_string_literal: true

require 'rails_helper'

describe 'Register new user', type: :feature do
  let(:valid_user) { build(:user) }
  let(:user_with_invalid_email_format) { build(:user_with_invalid_email) }
  let(:user_with_invalid_password_length) { build(:user_with_invalid_password) }

  scenario 'valid inputs' do
    visit sign_up_path
    fill_in 'Email', with: valid_user.email
    fill_in 'user_password', with: valid_user.password
    fill_in 'user_password_confirmation', with: valid_user.password
    click_on 'Sign Up'

    expect(current_path).to eq edit_user_path(User.first)
    expect(page).to have_content 'Sign up successfully'
  end

  context 'sign up existing user' do
    let(:user) { create(:user, username: valid_user.email.split('@').first) }
    before do
      visit sign_up_path
    end

    scenario 'with existed email' do
      fill_in 'Email', with: user.email
      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password
      click_on 'Sign Up'

      expect(current_path).to eq sign_up_path
      expect(page).to have_content 'Email has already been taken'
    end
  end

  context 'invalid inputs' do
    before { visit sign_up_path }

    scenario 'with invalid email format' do
      fill_in 'Email', with: user_with_invalid_email_format.email
      fill_in 'user_password', with: user_with_invalid_email_format.password
      fill_in 'user_password_confirmation', with: user_with_invalid_email_format.password
      click_on 'Sign Up'

      expect(current_path).to eq sign_up_path
      expect(page).to have_content 'Email Invalid format'
    end

    scenario 'with invalid password lengeth' do
      fill_in 'Email', with: user_with_invalid_password_length.email
      fill_in 'user_password', with: user_with_invalid_password_length.password
      fill_in 'user_password_confirmation', with: user_with_invalid_password_length.password
      click_on 'Sign Up'

      expect(current_path).to eq sign_up_path
      expect(page).to have_content 'Password is too short (minimum is 8 characters)'
    end

    scenario 'with unmatched password confirmation' do
      fill_in 'Email', with: valid_user.email
      fill_in 'user_password', with: valid_user.password
      fill_in 'user_password_confirmation', with: 'unmatchedpwd'
      click_on 'Sign Up'

      expect(current_path).to eq sign_up_path
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end
end
