require 'rails_helper'

RSpec.describe ResetPasswordForm do
  let(:user) { create(:user_with_unexpired_reset_token) }
  let(:subject) { described_class.new(user) }
  let(:user_params) do
    {
      password: user.password,
      password_confirmation: user.password
    }
  end

  describe 'validate' do
    context 'with unexpired user' do
      it 'returns true' do
        expect(subject.validate(user_params)).to be_truthy
      end

      it 'has no error messages' do
        subject.validate(user_params)

        expect(subject.errors).to be_empty
      end

      context 'with invalid password length' do
        let(:invalid_password) { Faker::Internet.password(min_length: 1, max_length: ENV['PASSWORD_MIN_LENGTH'].to_i - 1) }
        let(:user_params) do
          {
            password: invalid_password,
            password_confirmation: invalid_password
          }
        end

        it 'returns false' do
          expect(subject.validate(user_params)).to be_falsey
        end

        it 'has error messages' do
          subject.validate(user_params)

          expect(subject.errors).not_to be_empty
          expect(subject.errors.full_messages).to eq(['Password is too short (minimum is 8 characters)'])
        end
      end

      context 'with unmatched password confirmation' do
        let(:user_params) do
          {
            password: user.password,
            password_confirmation: 'unmatched'
          }
        end

        it 'returns false' do
          expect(subject.validate(user_params)).to be_falsey
        end

        it 'has error messages' do
          subject.validate(user_params)

          expect(subject.errors).not_to be_empty
          expect(subject.errors.full_messages).to eq(["Password confirmation doesn't match Password"])
        end
      end
    end

    context 'with expired user' do
      let(:user) { create(:user_with_expired_reset_token) }

      it 'returns false' do
        expect(subject.validate(user_params)).to be_falsey
      end

      it 'has error messages' do
        subject.validate(user_params)

        expect(subject.errors).not_to be_empty
      end

      context 'with invalid password length' do
        let(:invalid_password) { Faker::Internet.password(min_length: 1, max_length: ENV['PASSWORD_MIN_LENGTH'].to_i - 1) }
        let(:user_params) do
          {
            password: invalid_password,
            password_confirmation: invalid_password
          }
        end

        it 'returns false' do
          expect(subject.validate(user_params)).to be_falsey
        end

        it 'has error messages' do
          subject.validate(user_params)

          expect(subject.errors).not_to be_empty
          expect(subject.errors.full_messages).to eq(['Password is too short (minimum is 8 characters)',
                                                      'Reset link has already expired'])
        end
      end

      context 'with unmatched password confirmation' do
        let(:user_params) do
          {
            password: user.password,
            password_confirmation: 'unmatched'
          }
        end

        it 'returns false' do
          expect(subject.validate(user_params)).to be_falsey
        end

        it 'has error messages' do
          subject.validate(user_params)

          expect(subject.errors).not_to be_empty
          expect(subject.errors.full_messages).to eq(["Password confirmation doesn't match Password",
                                                      'Reset link has already expired'])
        end
      end
    end
  end

  describe '#save' do
    before { subject.validate(user_params) }

    it { expect(subject.save).to be_truthy }
  end
end
