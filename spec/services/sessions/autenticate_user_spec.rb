require 'rails_helper'

module Sessions
  RSpec.describe AuthenticateUser do
    let(:user) { create(:user) }
    let(:locked_user) { create(:locked_user) }
    let(:expire_time) { ENV['VALID_RESET_TOKEN_DURATION'].to_i.hours.since }
    let(:delivered) { ActionMailer::Base.deliveries }
    let(:user_params) do
      {
        email: user.email,
        password: user.password
      }
    end

    let(:subject) { described_class.call(user, user_params) }

    describe '#call' do
      it 'return itself' do
        expect(subject.class).to eq described_class
      end
    end

    describe '#authorized?' do
      context 'with correct sign in information' do
        it 'return true' do
          expect(subject.authorized?).to be_truthy
        end
      end

      context 'with incorrect password' do
        let(:user_params) do
          {
            email: user.email,
            password: Faker::Internet.password
          }
        end

        it 'return false' do
          expect(subject.authorized?).to be_falsey
        end
      end

      context 'with incorrect email' do
        let(:user_params) do
          {
            email: Faker::Internet.email,
            password: Faker::Internet.password
          }
        end

        it 'return false' do
          expect(subject.authorized?).to be_falsey
        end
      end

      context 'with locked user' do
        let(:user_params) do
          {
            email: locked_user.email,
            password: locked_user.password
          }
        end
        let(:subject) { described_class.call(locked_user, user_params) }

        it 'return false' do
          expect(subject.authorized?).to be_falsey
        end
      end
    end

    describe '#error_message' do
      context 'with correct sign in information' do
        it 'return true' do
          expect(subject.error_message).to be_nil
        end
      end

      context 'with incorrect password' do
        let(:user_params) do
          {
            email: user.email,
            password: Faker::Internet.password
          }
        end

        it 'return false' do
          expect(subject.error_message).to eq('The email or password you entered is incorrect')
        end
      end

      context 'with incorrect email' do
        let(:user_params) do
          {
            email: Faker::Internet.email,
            password: Faker::Internet.password
          }
        end

        it 'return false' do
          expect(subject.error_message).to eq('The email or password you entered is incorrect')
        end
      end

      context 'with locked user' do
        let(:user_params) do
          {
            email: locked_user.email,
            password: locked_user.password
          }
        end
        let(:subject) { described_class.call(locked_user, user_params) }

        it 'return false' do
          expect(subject.error_message).to eq('This account has been locked, please contact administrator for unlocking account')
        end
      end
    end
  end
end
