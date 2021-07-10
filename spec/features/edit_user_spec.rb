# frozen_string_literal: true

require 'rails_helper'

describe 'Edit user', type: :feature do
  let(:valid_user) { create(:user) }
  let(:other_user) { create(:user) }

  context 'with logged in user' do
    before do
      visit sign_in_path
      fill_in 'Email', with: valid_user.email
      fill_in 'Password', with: valid_user.password
      click_on 'Sign In'
    end

    scenario 'visit current logged in user edit page' do
      visit edit_user_path(valid_user)

      expect(current_path).to eq edit_user_path(valid_user)
      expect(page).to have_field 'Email'
      expect(page).to have_selector(:field, 'Email', readonly: true)
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
      expect(page).to have_button 'Update'
      expect(page).to have_button 'Sign Out'
      expect(page).not_to have_content 'You are not allowed to perform this action'
    end

    scenario 'visit other user edit page' do
      visit edit_user_path(other_user)

      expect(current_path).to eq edit_user_path(valid_user)
      expect(page).to have_field 'Email'
      expect(page).to have_selector(:field, 'Email', readonly: true)
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
      expect(page).to have_button 'Update'
      expect(page).to have_button 'Sign Out'
      expect(page).to have_content 'You are not allowed to perform this action'
    end
  end

  context 'without logged in user' do
    scenario 'visit user edit page' do
      visit edit_user_path(valid_user)

      expect(current_path).to eq root_path
      expect(page).to have_field 'Email'
      expect(page).to have_field 'Password'
      expect(page).to have_button 'Sign In'
      expect(page).to have_content 'You are not allowed to perform this action'
    end
  end
end
