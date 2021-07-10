# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordsController, type: :request do
  describe 'POST #create' do
    let(:valid_user) { create(:user) }

    context 'with exist user email' do
      let(:subject) do
        post '/passwords', params: {
          user: { email: valid_user.email }
        }
      end

      it 'response with 302' do
        subject

        expect(response).to have_http_status(302)
      end

      it 'add reset_password_token to user' do
        subject

        valid_user.reload
        expect(valid_user.reset_password_token).not_to be_nil
      end

      it 'add reset_token_expires_at to user' do
        subject

        valid_user.reload
        expect(valid_user.reset_token_expires_at).not_to be_nil
      end
    end

    context 'with non-exist user email' do
      let(:subject) do
        post '/passwords', params: {
          user: { email: Faker::Internet.email }
        }
      end

      it 'response with 302' do
        subject

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'PUT #update' do
    let(:unexpired_token_user) { create(:user_with_unexpired_reset_token) }
    let(:expired_token_user) { create(:user_with_expired_reset_token) }
    let(:valid_password) { Faker::Internet.password(min_length: ENV['PASSWORD_MIN_LENGTH'].to_i) }
    let(:unmatched_confirmation) { Faker::Internet.password(min_length: ENV['PASSWORD_MIN_LENGTH'].to_i) }
    let(:invalid_password) { Faker::Internet.password(min_length: 1, max_length: ENV['PASSWORD_MIN_LENGTH'].to_i - 1) }

    context 'with unexpired reset token' do
      context 'with valid password' do
        let(:subject) do
          put "/passwords/#{unexpired_token_user.reset_password_token}",
            params: { user: { password: valid_password,
                              password_confirmaiton: valid_password } }
        end

        it 'response with 302' do
          subject

          expect(response).to have_http_status(302)
        end

        it 'redirect to root path' do
          subject

          expect(response).to redirect_to root_path
        end

        it 'returns flash[:notice]' do
          subject

          expect(flash[:notice]).to be_present
          expect(flash[:notice]).to eq('Password changed')
        end
      end

      context 'with invalid password' do
        let(:subject) do
          put "/passwords/#{unexpired_token_user.reset_password_token}",
            params: { user: { password: invalid_password,
                              password_confirmaiton: invalid_password } }
        end

        it 'response with 302' do
          subject

          expect(response).to have_http_status(302)
        end

        it 'redirect to root path' do
          subject

          expect(response).to redirect_to root_path
        end

        it 'returns flash[:error]' do
          subject

          expect(flash[:error]).to be_present
          expect(flash[:error]).to eq(["Password is too short (minimum is 8 characters)"])
        end
      end

      context 'with unmatched password confimation' do
        let(:user_with_unmatched_confirmation) { { user: FactoryBot.attributes_for(:user_with_unmatched_confirmation) } }
        let(:subject) do
          put "/passwords/#{unexpired_token_user.reset_password_token}",
            params: user_with_unmatched_confirmation
        end

        it 'response with 302' do
          subject

          expect(response).to have_http_status(302)
        end

        it 'redirect to root path' do
          subject

          expect(response).to redirect_to root_path
        end

        it 'returns flash[:error]' do
          subject

          expect(flash[:error]).to be_present
          expect(flash[:error]).to eq(["Password confirmation doesn't match Password"])
        end
      end
    end

    context 'with expired reset token' do
      context 'with valid password' do
        let(:subject) do
          put "/passwords/#{expired_token_user.reset_password_token}",
            params: { user: { password: valid_password,
                              password_confirmaiton: valid_password } }
        end

        it 'response with 302' do
          subject

          expect(response).to have_http_status(302)
        end

        it 'redirect to root path' do
          subject

          expect(response).to redirect_to root_path
        end

        it 'returns flash[:error]' do
          subject

          expect(flash[:error]).to be_present
          expect(flash[:error]).to eq(['Reset link has already expired'])
        end
      end

      context 'with invalid password' do
        let(:subject) do
          put "/passwords/#{expired_token_user.reset_password_token}",
            params: { user: { password: invalid_password,
                              password_confirmaiton: invalid_password } }
        end

        it 'response with 302' do
          subject

          expect(response).to have_http_status(302)
        end

        it 'redirect to root path' do
          subject

          expect(response).to redirect_to root_path
        end

        it 'returns flash[:error]' do
          subject

          expect(flash[:error]).to be_present
          expect(flash[:error]).to eq(['Password is too short (minimum is 8 characters)', 'Reset link has already expired'])
        end
      end

      context 'with unmatched password confimation' do
        let(:user_with_unmatched_confirmation) { { user: FactoryBot.attributes_for(:user_with_unmatched_confirmation) } }
        let(:subject) do
          put "/passwords/#{unexpired_token_user.reset_password_token}",
            params: user_with_unmatched_confirmation
        end

        it 'response with 302' do
          subject

          expect(response).to have_http_status(302)
        end

        it 'redirect to root path' do
          subject

          expect(response).to redirect_to root_path
        end

        it 'returns flash[:error]' do
          subject

          expect(flash[:error]).to be_present
          expect(flash[:error]).to eq(["Password confirmation doesn't match Password"])
        end
      end
    end
  end
end
