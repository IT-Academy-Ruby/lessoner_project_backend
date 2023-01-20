FactoryBot.define do
  factory :category do
    sequence(:name) { |i| "Category#{i}" }
    sequence(:description) { |i| "Description #{i}" }
    status { 'active' }
  end
end
