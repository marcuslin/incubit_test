# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :locked_user do
      locked { true }
      failed_login_count { ENV['MAX_FAILED_LOGIN_ATTEMPT'] }
    end

    trait :failed_login_twice do
      failed_login_count { 2 }
    end

    trait :invalid_email do
      email { 'invalidemail' }
    end

    trait :unmatched_confirmation do
      password { Faker::Internet.password }
      password_confirmation { Faker::Internet.password }
    end

    trait :invalid_password do
      password { Faker::Internet.password.first(7) }
    end

    trait :expired_reset_token do
      reset_password_token { SecureRandom.hex(16) }
      reset_token_expires_at { ENV['VALID_RESET_TOKEN_DURATION'].to_i.hours.ago }
    end

    trait :unexpired_reset_token do
      reset_password_token { SecureRandom.hex(16) }
      reset_token_expires_at { ENV['VALID_RESET_TOKEN_DURATION'].to_i.hours.since }
    end

    factory :locked_user, traits: [:locked_user]
    factory :user_with_unmatched_confirmation, traits: [:unmatched_confirmation]
    factory :user_failed_login_twice, traits: [:failed_login_twice]
    factory :user_with_invalid_email, traits: [:invalid_email]
    factory :user_with_invalid_password, traits: [:invalid_password]
    factory :user_with_expired_reset_token, traits: [:expired_reset_token]
    factory :user_with_unexpired_reset_token, traits: [:unexpired_reset_token]
  end
end
