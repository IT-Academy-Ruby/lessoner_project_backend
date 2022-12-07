class LessonSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :lesson_image_url, :id, :title

  def lesson_image_url
    object.lesson_image.blob.attributes.slice('filename', 'id').merge(url: image_url)
  end
  
  def image_url
    object.lesson_image&.url&.split("?")&.first
  end
end
