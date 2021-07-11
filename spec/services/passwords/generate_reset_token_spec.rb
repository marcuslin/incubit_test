require 'rails_helper'

module Passwords
  RSpec.describe GenerateResetToken do
    let(:user) { create(:user) }
    let(:expire_time) { ENV['VALID_RESET_TOKEN_DURATION'].to_i.hours.since }
    let(:delivered) { ActionMailer::Base.deliveries }

    context 'existing user' do
      let(:subject) { described_class.call(user) }

      it 'add reset_password_token to user' do
        subject

        expect(user.reload.reset_password_token).not_to be_nil
      end

      it 'add reset_token_expires_at to user' do
        subject

        expect(user.reload.reset_token_expires_at).not_to be_nil
      end

      it 'should send reset password instruction' do
        expect { subject }.to change { delivered.count }.by(1)

        expect(delivered.last.to.first).to eq(user.email)
        expect(delivered.last.subject).to eq('Reset password instruction')
      end
    end

    context 'not-existing user' do
      let(:non_exist_user) { User.find_by(email: Faker::Internet.email) }
      let(:subject) { GenerateResetToken.call(non_exist_user) }

      it 'should not send reset password instruction' do
        expect { subject }.to change { delivered.count }.by(0)
      end
    end
  end
end
