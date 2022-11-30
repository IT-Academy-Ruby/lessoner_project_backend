# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  paginates_per MAX_ITEMS_PER_PAGE
  before_create :confirmation_token
  enum :gender, %i[male female other]
  validates :gender, presence: true
  validates :birthday, date: { after: proc { Time.zone.today - 120.years },
                               before: proc { Time.zone.today } }
  validates :name, presence: true, length: { in: 3..50 }, format: { with: /\A[a-z0-9]+\z/i },
                   uniqueness: true
  validates :email, presence: true, length: { in: 3..256 },
                    format: { with: %r/\A[a-zA-Z0-9!#$%&'*+\-\/=?^_`{|}~.]+@[a-z0-9\-.]*\z/ },
                    uniqueness: true
  validate :email_dots, if: -> { email.present? }

  # validate :password_special_character, if: -> { password.present? }
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
  # def password_special_character
  #  errors.add(:password, 'must contain at least 1 special character') if password.count("!#$%&'*+\-\/=?^_`{|}~").zero?
  # end

  def generate_password_token!
    self.password_reset_token = generate_token
    self.password_reset_sent_at = Time.now.utc
    save!(validate: false)
  end

  def password_token_valid?
    (password_reset_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.password_reset_token = nil
    self.password = password
    save!
  end

  def email_activate!
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end

  def confirmation_token
    return if confirm_token.present?

    self.confirm_token = generate_token
  end
end
