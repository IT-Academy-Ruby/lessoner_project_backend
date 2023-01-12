FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "User#{i}" }
    sequence(:email) do |i|
      "user#{i}@example.com"
    end
    phone { '+37529123-45-67' }
    gender { 'male' }
    birthday { '27.02.2001' }
    password_digest { '123456' }
    admin_type { false }
  end
end
