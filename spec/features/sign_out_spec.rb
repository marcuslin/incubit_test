# frozen_string_literal: true

require 'rails_helper'

describe 'Sign out', type: :feature do
  let(:user) { create(:user) }

  before do
    visit sign_in_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign In'
  end

  scenario 'with signed in user' do
    visit edit_user_path(user)
    click_on 'Sign Out'

    expect(current_path).to eq root_path
  end
end
