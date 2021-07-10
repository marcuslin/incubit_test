require 'rails_helper'

module Sessions
  RSpec.describe LockUser do
    let(:user) { create(:user) }

    let(:subject) { described_class.call(user) }

    describe '#call' do
      it 'return user' do
        expect(subject).to be_truthy
      end

      it 'increase user login_failed_count by 1' do
        expect {subject}.to change {user.reload.failed_login_count}.from(0).to(1)
      end

      context 'with user already failed twice' do
        let(:user) { create(:user_failed_login_twice) }

        it 'increase user login_failed_count by 1' do
          expect {subject}.to change {user.reload.failed_login_count}.from(2).to(3)
        end

        it 'locks user' do
          expect {subject}.to change {user.reload.locked}.from(false).to(true)
        end
      end
    end
  end
end
