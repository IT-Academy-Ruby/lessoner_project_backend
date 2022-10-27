# frozen_string_literal: true

class User < ApplicationRecord
  paginates_per MAX_ITEMS_PER_PAGE

  enum :gender, %i[male female other]
  validates :gender, presence: true
  validates :birthday, date: { after: proc { Time.zone.today - 120.years },
                               before: proc { Time.zone.today } }
  validates :name, presence: true, length: { in: 3..50 }, format: { with: /\A[a-z0-9]+\z/i },
                   uniqueness: true
  validates :email, presence: true, length: { in: 3..256 },
                    format: { with: %r/\A[a-zA-Z0-9!#$%&'*+\-\/=?^_`{|}~.]+@[a-z0-9\-.]*\z/ }
  validate :email_dots, if: -> { email.present? }

  validate :password_special_character, if: -> { password.present? }
  validates :password, presence: true, length: { in: 6..256 },
                       format: { with: %r/\A[a-z0-9!#$%&'*+\-\/=?^_`{|}~]+\z/i }
  validates :phone, phone: true, if: -> { phone.present? }

  has_many :comments, dependent: :destroy
  has_many :lessons, class_name: 'Lesson', foreign_key: 'author_id'

  # Validation for email: symbol . (dot) provided that it is neither the first nor the last,
  # and also if it is not repeated more than once in a row.
  def email_dots
    login = email.scan(/\S+@/).join
    errors.add(:email, 'has too many dots') if login.count('.') > 1 || login[0] == '.' || login[-2] == '.'
  end

  # Validation for password: must contain at least 1 special character.
  def password_special_character
    errors.add(:password, 'must contain at least 1 special character') if password.count("!#$%&'*+\-\/=?^_`{|}~").zero?
  end
end
