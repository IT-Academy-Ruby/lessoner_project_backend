# frozen_string_literal: true

class Lesson < ApplicationRecord
  paginates_per MAX_ITEMS_PER_PAGE
  has_many :comments, dependent: :destroy
  belongs_to :author, class_name: "User", foreign_key: "author_id"
end
