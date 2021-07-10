# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationsController, type: :request do
  describe 'GET #new' do
    before { get '/sign_up' }

    it { expect(assigns(:form).model).to be_a_new(User) }
  end

  describe 'POST /sign_up' do
    let(:created_user) { User.first }

    context 'when valid user' do
      let(:subject) { post '/sign_up', params: valid_user }
      let(:valid_user) { { user: attributes_for(:user) } }

      it 'response with 302' do
        subject

        expect(response).to have_http_status(302)
      end

      it 'redirect to edit_user_path with flash[:notice]' do
        subject

        expect(flash[:notice]).to be_present
        expect(flash[:notice]).to eq('Sign up successfully')
        expect(response).to redirect_to edit_user_path(User.first.id)
      end

      it 'has correct username' do
        subject

        expect(created_user.username).to eq(created_user.email.split('@').first)
      end

      it 'create user' do
        expect { subject }.to change { User.count }.from(0).to(1)
        expect(assigns(:form).model).to eq created_user
      end

      it 'send welcome email' do
        delivered = ActionMailer::Base.deliveries

        expect { subject }.to change { delivered.count }.by(1)

        expect(delivered.last.to.first).to eq(created_user.email)
        expect(delivered.last.subject).to eq('Welcome')
      end
    end

    context 'when email invalid' do
      let(:user_with_invalid_email) { { user: attributes_for(:user_with_invalid_email) } }
      let(:subject) { post '/sign_up', params: user_with_invalid_email }

      it 'response with 200' do
        subject

        expect(response).to have_http_status(200)
      end

      it 'renders new with flash[:error]' do
        subject

        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq ['Email Invalid format']
      end

      it 'do not create user' do
        subject

        expect(User.count).to eq(0)
      end

      it 'do not send welcome email' do
        delivered = ActionMailer::Base.deliveries

        subject

        expect(delivered.count).to eq 0
      end
    end

    context 'when password invalid' do
      let(:user_with_invalid_password) { { user: attributes_for(:user_with_invalid_password) } }
      let(:subject) { post '/sign_up', params: user_with_invalid_password }

      it 'response with 200' do
        subject

        expect(response).to have_http_status(200)
      end

      it 'renders new with flash[:error]' do
        subject

        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq ['Password is too short (minimum is 8 characters)']
      end

      it 'do not create user' do
        subject

        expect(User.count).to eq(0)
      end

      it 'do not send welcome email' do
        delivered = ActionMailer::Base.deliveries

        subject

        expect(delivered.count).to eq 0
      end
    end

    context 'when confirmation not matched' do
      let(:user_with_unmatched_confirmation) { { user: attributes_for(:user_with_unmatched_confirmation) } }
      let(:subject) { post '/sign_up', params: user_with_unmatched_confirmation }

      it 'response with 200' do
        subject

        expect(response).to have_http_status(200)
      end

      it 'renders new with flash[:error]' do
        subject

        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq ["Password confirmation doesn't match Password"]
      end

      it 'do not create user' do
        subject

        expect(User.count).to eq(0)
      end

      it 'do not send welcome email' do
        delivered = ActionMailer::Base.deliveries

        subject

        expect(delivered.count).to eq 0
      end
    end

    context 'Sign up as an existing user' do
      let!(:existed_user) { create(:user, username: Faker::Internet.username) }
      let(:duplicate_user) do
        {
          user: {
            email: existed_user.email,
            password: existed_user.password
          }
        }
      end
      let(:subject) { post '/sign_up', params: duplicate_user }

      it 'response with 200' do
        subject

        expect(response).to have_http_status(200)
      end

      it 'renders new with flash[:error]' do
        subject

        expect(response).to render_template(:new)
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq ['Email has already been taken']
      end

      it 'do not create user' do
        subject

        expect(User.count).to eq(1)
      end

      it 'do not send welcome email' do
        delivered = ActionMailer::Base.deliveries

        subject

        expect(delivered.count).to eq 0
      end
    end
  end
end
