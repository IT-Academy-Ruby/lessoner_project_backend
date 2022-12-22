class Category < ApplicationRecord
  STATUSES = %i[active archived].freeze
  has_one_attached :image, dependent: :destroy

  enum :status, STATUSES

  validates :image, attached: false, content_type: %w[image/jpeg image/gif image/png image/jpg],
                    size: { less_than: 5.megabytes, message: 'is too large' }
  validates :name, presence: true, length: { maximum: TITLE_MAX_SIZE },
                   format: { with: REG_EXP_FOR_LESSON, message: 'The input field contains prohibited characters' },
                   uniqueness: true
  validates :description, presence: true, length: { maximum: DESCRIPTION_MAX_SIZE },
                          format: { with: REG_EXP_FOR_LESSON,
                                    message: 'The input field contains prohibited characters' },
                          uniqueness: true

  has_many :lessons
end
