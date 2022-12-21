FactoryBot.define do
  factory :lesson do
    description { 'Lesson description' }
    title { 'Lesson title' }
    video_link { 'Lesson link' }
    # user { nil }
    # category { nil }
    status { 0 }
  end
end
