# frozen_string_literal: true

require 'rails_helper'

describe 'Update user', type: :feature do
  let(:valid_user) { create(:user) }
  let(:valid_username) { Faker::Internet.username(specifier: ENV['USERNAME_MIN_LENGTH'].to_i) }
  let(:valid_password) { Faker::Internet.password(min_length: ENV['PASSWORD_MIN_LENGTH'].to_i) }
  let(:unmatched_confirmation) { Faker::Internet.password(min_length: ENV['PASSWORD_MIN_LENGTH'].to_i) }
  let(:invalid_username) { Faker::Internet.username(specifier: 1..ENV['USERNAME_MIN_LENGTH'].to_i - 1) }
  let(:invalid_password) { Faker::Internet.password(min_length: 1, max_length: ENV['PASSWORD_MIN_LENGTH'].to_i - 1) }

  context 'with login user' do
    before do
      visit sign_in_path
      fill_in 'Email', with: valid_user.email
      fill_in 'Password', with: valid_user.password
      click_on 'Sign In'
    end

    scenario 'update with valid information' do
      visit edit_user_path(valid_user)

      fill_in 'Username', with: valid_username
      fill_in 'user_password', with: valid_password
      fill_in 'user_password_confirmation', with: valid_password

      click_on 'Update'

      expect(current_path).to eq edit_user_path(valid_user)
      expect(page).to have_field 'Email'
      expect(page).to have_selector(:field, 'Email', readonly: true)
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
      expect(page).to have_button 'Update'
      expect(page).to have_button 'Sign Out'
      expect(page).to have_content 'Updated successfully'
    end

    scenario 'update with invalid username' do
      visit edit_user_path(valid_user)

      fill_in 'Username', with: invalid_username
      fill_in 'user_password', with: valid_password
      fill_in 'user_password_confirmation', with: valid_password

      click_on 'Update'

      expect(current_path).to eq edit_user_path(valid_user)
      expect(page).to have_field 'Email'
      expect(page).to have_selector(:field, 'Email', readonly: true)
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
      expect(page).to have_button 'Update'
      expect(page).to have_button 'Sign Out'
      expect(page).to have_content "Username is too short (minimum is #{ENV['USERNAME_MIN_LENGTH']} characters)"
    end

    scenario 'update with invalid password' do
      visit edit_user_path(valid_user)

      fill_in 'Username', with: valid_username
      fill_in 'user_password', with: invalid_password
      fill_in 'user_password_confirmation', with: invalid_password

      click_on 'Update'

      expect(current_path).to eq edit_user_path(valid_user)
      expect(page).to have_field 'Email'
      expect(page).to have_selector(:field, 'Email', readonly: true)
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
      expect(page).to have_button 'Update'
      expect(page).to have_button 'Sign Out'
      expect(page).to have_content "Password is too short (minimum is #{ENV['PASSWORD_MIN_LENGTH']} characters)"
    end

    scenario 'update with unmatched password and confirmation' do
      visit edit_user_path(valid_user)

      fill_in 'Username', with: valid_username
      fill_in 'user_password', with: valid_password
      fill_in 'user_password_confirmation', with: unmatched_confirmation

      click_on 'Update'

      expect(current_path).to eq edit_user_path(valid_user)
      expect(page).to have_field 'Email'
      expect(page).to have_selector(:field, 'Email', readonly: true)
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
      expect(page).to have_button 'Update'
      expect(page).to have_button 'Sign Out'
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end
end
