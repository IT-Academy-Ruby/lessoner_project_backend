class Lesson < ApplicationRecord
  include Filterable

  STATUSES = %i[active archived].freeze

  has_many :comments, dependent: :destroy
  has_many :lesson_views, dependent: :destroy
  belongs_to :author, class_name: 'User'
  enum :status, STATUSES

  validates :title, presence: true,
                    length: { maximum: TITLE_MAX_SIZE,
                              too_long: "The maximum allowed number of character is #{TITLE_MAX_SIZE}" },
                    format: { with: REG_EXP_FOR_LESSON }
  validates :description, presence: true,
                          length: { maximum: DESCRIPTION_MAX_SIZE,
                                    too_long: "The maximum allowed number of character is #{DESCRIPTION_MAX_SIZE}" },
                          format: { with: REG_EXP_FOR_LESSON,
                                    message: 'This character is not available for input in this field' }
  validates :video_link, presence: true, url: { message: 'Please check the correctness of the link' }
  validates :category_id, presence: true

  scope :filter_by_status, ->(status) { where status: }
  scope :filter_by_category_id, ->(category_id) { where category_id: }
end
