FactoryBot.define do
  factory :user do
    name { 'User' }
    email { 'user@gmail.com' }
    description { 'User description' }
    uid { '123456789' }
    avatar_url { 'https://lessoner.s3.amazonaws.com/image-url' }
    provider { 'provider' }
    phone { '+375291234567' }
    gender { 0 }
    birthday { '2000-01-01' }
    password_digest { '123456' }
    password_reset_token { nil }
    password_reset_sent_at { nil }
    email_confirmed { true }
    confirm_token { nil }
    admin_type { false }
  end
end
