# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
end
