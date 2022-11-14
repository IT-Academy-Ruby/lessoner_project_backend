# frozen_string_literal: true

class Lesson < ApplicationRecord
  STATUSES = %i[active archived].freeze

  paginates_per MAX_ITEMS_PER_PAGE
  has_many :comments, dependent: :destroy
  belongs_to :author, class_name: 'User'
  enum :status, STATUSES

  validates :title, presence: true, length: { maximum: 64, too_long: 'The maximum allowed number of character is 64' },
                    format: { with: %r/\A[а-яА-ЯёЁa-zA-Z0-9`:%&'"@,><{|}=_~\-!()$*+\/?\^.\[\]]+\z/ }
  validates :description, presence: true,
                          length: { maximum: 600, too_long: 'The maximum allowed number of character is 600' },
                          format: { with: %r/\A[а-яА-ЯёЁa-zA-Z0-9`%&'"@,><{|}=_~\-!()$*+\/?\^.\[\]]+\z/,
                                    message: 'This character is not available for input in this field' }
  validates :video_link, presence: true, url: { message: 'Please check the correctness of the link' }
  validates :category_id, presence: true
end
