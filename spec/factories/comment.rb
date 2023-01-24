FactoryBot.define do
  factory :comment do
    body { 'My comment' }
    association :lesson
    association :user
  end
end
