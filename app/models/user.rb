class User < ApplicationRecord
  has_many :comments

  validates :name, :email, presence: true
end
