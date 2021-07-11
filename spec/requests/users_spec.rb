# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'GET #edit' do
    let(:user) { create(:user) }
    let(:subject) { get "/users/#{user.id}/edit"}

    it 'build a new user' do
      subject

      expect(assigns(:form).model).to eq user
    end

    context 'without sigining in' do
      it 'response 302' do
        subject

        expect(response).to have_http_status(302)
      end

      it 'redirect to root_path' do
        subject

        expect(response).to redirect_to root_path
      end
    end

    context 'with sigining in' do
      before do
        post '/sign_in',
          params: { user:
                    { email: user.email,
                      password: user.password } }
      end

      it 'gets user by passed id' do
        subject

        expect(assigns(:form).model).to eq user
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:username) { Faker::Internet.username(specifier: ENV['USERNAME_MIN_LENGTH'].to_i) }
    let!(:valid_password) do
      Faker::Internet
        .password(min_length: ENV['PASSWORD_MIN_LENGTH'].to_i)
    end
    let(:subject) do
      put "/users/#{user.id}",
        params: { user: {
          username: username,
          password: valid_password,
          password_confirmation: valid_password
        } }
    end

    context 'without sigining in' do
      it 'response 302' do
        subject

        expect(response).to have_http_status(302)
      end

      it 'redirect to root_path with error message' do
        subject

        expect(response).to redirect_to root_path
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('You are not allowed to perform this action')
      end
    end

    context 'signed in' do
      before do
        post '/sign_in',
          params: { user:
                    { email: user.email,
                      password: user.password } }
      end

      context 'perform update on current user' do
        context 'with correct information' do
          it 'response 302' do
            subject

            expect(response).to have_http_status(302)
          end

          it 'redirect to edit_path with flash[:notice]' do
            subject

            expect(response).to redirect_to edit_user_path(user)
            expect(flash[:notice]).to be_present
            expect(flash[:notice]).to eq('Updated successfully')
          end

          it "will update users' username" do
            subject

            expect(user.reload.username).to eq username
          end

          it "will update users' password" do
            subject

            expect{ subject; user.reload }.to change { user.authenticate(valid_password) }.from(false).to(user)
            expect(user.reload.authenticate(valid_password)).to eq user
          end
        end

        context 'update username with correct password not matching password confirmation' do
          let(:subject) do
            put "/users/#{user.id}",
              params: { user: {
                username: username,
                password: user.password,
                password_confirmation: Faker::Internet.password
              } }
          end

          it 'response 302' do
            subject

            expect(response).to have_http_status(302)
          end

          it 'redirect to edit_path with flash[:error]' do
            subject

            expect(response).to redirect_to edit_user_path(user)
            expect(flash[:error]).to be_present
            expect(flash[:error]).to eq(["Password confirmation doesn't match Password"])
          end

          it "will not update users' username" do
            subject

            expect(user.reload.username).not_to eq username
          end

          it "will not update users' password" do
            subject

            expect{ subject; user.reload }.to_not change { user.authenticate(valid_password) }
            expect(user.reload.authenticate(valid_password)).to be_falsey
          end
        end

        context "update username with username.size lesser than #{ENV['USERNAME_MIN_LENGTH']}" do
          let(:incorrect_username) do
            Faker::Internet
              .username(specifier: 1..ENV['USERNAME_MIN_LENGTH'].to_i - 1)
          end
          let(:subject) do
            put "/users/#{user.id}",
              params: { user: {
                username: incorrect_username,
                password: user.password,
                password_confirmation: user.password
              } }
          end

          it 'response 302' do
            subject

            expect(response).to have_http_status(302)
          end

          it 'redirect to edit_path with flash[:error]' do
            subject

            expect(response).to redirect_to edit_user_path(user)
            expect(flash[:error]).to be_present
            expect(flash[:error]).to eq(["Username is too short (minimum is #{ENV['USERNAME_MIN_LENGTH']} characters)"])
          end

          it "will not update users' username" do
            subject

            expect(user.reload.username).not_to eq incorrect_username
          end
        end

        context "update password with size lesser than #{ENV['PASSWORD_MIN_LENGTH']}" do
          let(:incorrect_password) do
            Faker::Internet
              .password(min_length: 1,
                        max_length: ENV['PASSWORD_MIN_LENGTH'].to_i - 1)
          end
          let(:subject) do
            put "/users/#{user.id}",
              params: { user: {
                username: username,
                password: incorrect_password,
                password_confirmation: incorrect_password
              } }
          end

          it 'response 302' do
            subject

            expect(response).to have_http_status(302)
          end

          it 'redirect to edit_path with flash[:error]' do
            subject

            expect(response).to redirect_to edit_user_path(user)
            expect(flash[:error]).to be_present
            expect(flash[:error]).to eq(["Password is too short (minimum is #{ENV['PASSWORD_MIN_LENGTH']} characters)"])
          end

          it "will not update users' password" do
            subject

            expect(user.reload.password).not_to eq incorrect_password
          end

          it "will not update users' password" do
            subject

            expect{ subject; user.reload }.to_not change { user.authenticate(valid_password) }
            expect(user.reload.authenticate(valid_password)).to be_falsey
          end
        end
      end

      context 'perform update on other user' do
        let(:subject) do
          put "/users/#{other_user.id}",
            params: { user: {
              username: username,
              password: other_user.password,
              password_confirmation: other_user.password
            } }
        end

        it 'response 302' do
          subject

          expect(response).to have_http_status(302)
        end

        it 'redirect to root_path with error message' do
          subject

          expect(response).to redirect_to root_path
          expect(flash[:error]).to be_present
          expect(flash[:error]).to eq('You are not allowed to perform this action')
        end

        it "will not update other users' username" do
          subject

          expect(other_user.reload.username).to eq other_user.username
          expect(other_user.reload.username).not_to eq username
        end

        it "will not update other users' password" do
          subject

          expect{ subject; other_user.reload }.to_not change { other_user.authenticate(valid_password) }
          expect(other_user.reload.authenticate(valid_password)).to be_falsey
        end
      end
    end
  end
end
