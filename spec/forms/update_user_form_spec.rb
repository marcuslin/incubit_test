require 'rails_helper'

RSpec.describe UpdateUserForm do
  let(:user) { create(:user_with_unexpired_reset_token) }
  let(:subject) { described_class.new(user) }
  let(:valid_username) { Faker::Internet.username(specifier: ENV['USERNAME_MIN_LENGTH'].to_i) }
  let(:invalid_username) { Faker::Internet.username(specifier: 1..ENV['USERNAME_MIN_LENGTH'].to_i - 1) }
  let(:valid_password) { Faker::Internet.password(min_length: ENV['PASSWORD_MIN_LENGTH'].to_i) }
  let(:invalid_password) { Faker::Internet.password(min_length: 1, max_length: ENV['PASSWORD_MIN_LENGTH'].to_i - 1) }
  let(:user_params) do
    {
      username: valid_username,
      password: user.password,
      password_confirmation: user.password
    }
  end

  describe '#validate' do
    context 'with valid information' do
      it 'returns true' do
        expect(subject.validate(user_params)).to be_truthy
      end

      it 'has no errors' do
        subject.validate(user_params)

        expect(subject.errors).to be_empty
      end
    end

    context 'with valid password length' do
      let(:user_params) do
        {
          username: valid_username,
          password: invalid_password,
          password_confirmation: invalid_password
        }
      end

      it 'returns false' do
        expect(subject.validate(user_params)).to be_falsey
      end

      it 'has no errors' do
        subject.validate(user_params)

        expect(subject.errors).not_to be_empty
      end
    end

    context 'with valid username length' do
      let(:user_params) do
        {
          username: invalid_username,
          password: valid_password,
          password_confirmation: valid_password
        }
      end

      it 'returns false' do
        expect(subject.validate(user_params)).to be_falsey
      end

      it 'has no errors' do
        subject.validate(user_params)

        expect(subject.errors).not_to be_empty
      end
    end

    context 'with unmatched password confirmation' do
      let(:user_params) do
        {
          username: valid_username,
          password: valid_password,
          password_confirmation: 'unmatched'
        }
      end

      it 'returns false' do
        expect(subject.validate(user_params)).to be_falsey
      end

      it 'has no errors' do
        subject.validate(user_params)

        expect(subject.errors).not_to be_empty
      end
    end
  end

  describe '#save' do
    before { subject.validate(user_params) }

    it { expect(subject.save).to be_truthy }
  end
end
