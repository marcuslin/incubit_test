# frozen_string_literal: true

module Sessions
  class LockUser
    include Serviceable

    def initialize(user)
      @user = user
    end

    def call
      increase_failed_login_counts

      perform_acocunt_lock if reach_max_failed_login_attempt?

      user.save
    end

    private

    attr_accessor :user

    def perform_acocunt_lock
      user.locked = true
    end

    def increase_failed_login_counts
      user.failed_login_count += 1
    end

    def reach_max_failed_login_attempt?
      user.failed_login_count >= ENV['MAX_FAILED_LOGIN_ATTEMPT'].to_i
    end
  end
end
