# frozen_string_literal: true

require 'rails_helper'

describe 'Sign in', type: :feature do
  let(:valid_user) { create(:user) }
  let(:locked_user) { create(:locked_user) }

  scenario 'with correct sign in info' do
    visit sign_in_path
    fill_in 'Email', with: valid_user.email
    fill_in 'Password', with: valid_user.password
    click_on 'Sign In'

    expect(current_path).to eq edit_user_path(valid_user)
    expect(page).to have_content 'Signed in'
    expect(page).to have_field 'Email'
    expect(page).to have_selector(:field, 'Email', readonly: true)
    expect(page).to have_field 'Password'
    expect(page).to have_field 'Password confirmation'
    expect(page).to have_button 'Update'
    expect(page).to have_button 'Sign Out'
  end

  context 'with Incorrect sign in info' do
    scenario 'with Incorrect password' do
      visit sign_in_path
      fill_in 'Email', with: valid_user.email
      fill_in 'Password', with: "incorect#{valid_user.password}"
      click_on 'Sign In'

      expect(current_path).to eq sign_in_path
      expect(page).to have_content 'The email or password you entered is incorrect'
    end

    scenario 'with Incorrect email' do
      visit sign_in_path
      fill_in 'Email', with: "incorect#{valid_user.email}"
      fill_in 'Password', with: valid_user.password
      click_on 'Sign In'

      expect(current_path).to eq sign_in_path
      expect(page).to have_content 'The email or password you entered is incorrect'
    end

    scenario 'with Incorrect email and password' do
      visit sign_in_path
      fill_in 'Email', with: "incorect#{valid_user.email}"
      fill_in 'Password', with: "incorect#{valid_user.password}"
      click_on 'Sign In'

      expect(current_path).to eq sign_in_path
      expect(page).to have_content 'The email or password you entered is incorrect'
    end

    scenario 'with locked user and incorrect password' do
      visit sign_in_path
      fill_in 'Email', with: locked_user.email
      fill_in 'Password', with: locked_user.password
      click_on 'Sign In'

      expect(current_path).to eq sign_in_path
      expect(page).to have_content 'This account has been locked, please contact administrator for unlocking account'
    end

    scenario 'with locked user and correct password' do
      visit sign_in_path
      fill_in 'Email', with: locked_user.email
      fill_in 'Password', with: locked_user.password.first(7)
      click_on 'Sign In'

      expect(current_path).to eq sign_in_path
      expect(page).to have_content 'The email or password you entered is incorrect'
    end
  end
end
