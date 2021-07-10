require 'rails_helper'

RSpec.describe RegistrationForm do
  let(:user_params) { attributes_for(:user) }
  let(:subject) { described_class.new(User.new) }

  describe 'validate' do
    context 'with valid user' do
      it 'returns true' do
        expect(subject.validate(user_params)).to be_truthy
      end

      it 'has no error messages' do
        subject.validate(user_params)

        expect(subject.errors).to be_empty
      end
    end

    context 'with invalid email format' do
      let(:user_params) { attributes_for(:user_with_invalid_email) }

      it 'returns false' do
        expect(subject.validate(user_params)).to be_falsey
      end

      it 'has error messages' do
        subject.validate(user_params)

        expect(subject.errors).not_to be_empty
        expect(subject.errors.full_messages).to eq(['Email Invalid format'])
      end
    end

    context 'with invalid password length' do
      let(:user_params) { attributes_for(:user_with_invalid_password) }

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
      let(:user_params) { attributes_for(:user_with_unmatched_confirmation) }

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

  describe '#save' do
    before { subject.validate(user_params) }

    it { expect(subject.save).to be_truthy }
  end
end
