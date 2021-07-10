# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  describe 'GET #new' do
    let(:subject) { get '/sign_in' }
    let(:user) { create(:user) }

    context "haven't signed in" do
      it { expect(subject).not_to redirect_to edit_user_path(user) }
    end

    context 'already signed in' do
      before do
        post '/sign_in',
          params: { user:
                    { email: user.email,
                      password: user.password } }
      end

      it { expect(subject).to redirect_to edit_user_path(user) }
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'with valid sign in information' do
      let(:subject) do
        post '/sign_in',
          params: { user:
                    { email: user.email,
                      password: user.password } }
      end

      it 'response with 302' do
        subject

        expect(response).to have_http_status(302)
      end

      it 'redirect to edit_user_path with flash[:notice]' do
        subject

        expect(flash[:notice]).to be_present
        expect(flash[:notice]).to eq('Signed in')
        expect(response).to redirect_to edit_user_path(user.id)
      end
    end

    context 'with invalid email' do
      let(:invalid_user) { build(:user) }
      let(:subject) do
        post '/sign_in',
          params: { user:
                    { email: invalid_user.email,
                      password: invalid_user.password } }
      end

      it 'response with 200' do
        subject

        expect(response).to have_http_status(200)
      end

      it 'render :new with flash[:error]' do
        subject

        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('The email or password you entered is incorrect')
      end
    end

    context 'with invalid password' do
      let(:subject) do
        post '/sign_in',
          params: { user:
                    { email: user.email,
                      password: user.password.first(7) } }
      end

      it 'response with 200' do
        subject

        expect(response).to have_http_status(200)
      end

      it 'increase failed login count by 1' do
        expect { subject }.to change { user.reload.failed_login_count }.from(0).to(1)
      end

      it 'render :new with flash[:error]' do
        subject

        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('The email or password you entered is incorrect')
      end
    end

    context 'with user has already logged in fail twice' do
      let(:failed_twice_user) { create(:user_failed_login_twice) }
      let(:subject) do
        post '/sign_in',
          params: { user:
                    { email: failed_twice_user.email,
                      password: failed_twice_user.password.first(7) } }
      end

      it 'response with 200' do
        subject

        expect(response).to have_http_status(200)
      end

      it 'increase failed login count by 1' do
        expect { subject }.to change { failed_twice_user.reload.failed_login_count }.from(2).to(3)
      end

      it 'change locked status to True' do
        expect { subject }.to change { failed_twice_user.reload.locked }.from(false).to(true)
      end

      it 'render :new with flash[:error]' do
        subject

        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('The email or password you entered is incorrect')
      end
    end

    context 'with locked user by incorrect sign in information' do
      let(:locked_user) { create(:locked_user) }
      let(:subject) do
        post '/sign_in',
          params: { user:
                    { email: locked_user.email,
                      password: locked_user.password.first(7) } }
      end

      it 'response with 200' do
        subject

        expect(response).to have_http_status(200)
      end

      it 'render :new with flash[:error]' do
        subject

        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('The email or password you entered is incorrect')
      end
    end

    context 'with locked user by correct sign in information' do
      let(:locked_user) { create(:locked_user) }
      let(:subject) do
        post '/sign_in',
          params: { user:
                    { email: locked_user.email,
                      password: locked_user.password } }
      end

      it 'response with 200' do
        subject

        expect(response).to have_http_status(200)
      end

      it 'render :new with flash[:error]' do
        subject

        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('This account has been locked, please contact administrator for unlocking account')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:subject) { delete '/sign_out' }
    let(:user) { create(:user) }
    before do
      post '/sign_in',
        params: { user:
                  { email: user.email,
                    password: user.password } }
    end

    it 'clear session[:user_id]' do
      subject

      expect(session[:user]).to be_nil
    end
  end
end
