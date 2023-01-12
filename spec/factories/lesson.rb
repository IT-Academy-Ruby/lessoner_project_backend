FactoryBot.define do
  factory :lesson do
    description { 'Lesson description' }
    title { 'Ruby' }
    video_link { 'http://video.com/my-video' }
    status { 'active' }
    rating { 0.0 }
    image_link { 'http://image_link' }
    votes_count { 3 }
    association :author, factory: :user
    association :category
  end
end
