# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :avatar, dependent: :destroy
  has_secure_password
  before_create :confirmation_token
  before_validation { email.downcase! }
  before_validation { name.downcase! }
  enum :gender, %i[male female other]
  validates :avatar, attached: false, content_type: %w[image/jpeg image/png image/jpg]
  validates :gender, presence: true
  validates :birthday, date: { after: proc { Time.zone.today - 120.years },
                               before: proc { Time.zone.today } }
  validates :name, presence: true, length: { in: 3..50 }, format: { with: /\A[a-z0-9]+\z/i },
                   uniqueness: true
  validates :email, presence: true, length: { in: 3..256 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :password, presence: true, length: { in: 6..256 },
                       format: { with: %r/\A[a-z0-9!#$%&'*+\-\/=?^_`{|}~]+\z/i }, if: -> { password.present? }
  validates :phone, phone: true, if: -> { phone.present? }

  has_many :comments, dependent: :destroy
  has_many :lessons, class_name: 'Lesson', foreign_key: 'author_id'

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

  def generate_update_email_token!
    return if update_email_token.present?

    self.update_email_token = generate_token
    self.update_email_token_sent_at = Time.now.utc
    save!(validate: false)
  end

  def update_email_token_valid?
    (update_email_token_sent_at + 24.hours) > Time.now.utc
  end

  def update_email!(email)
    self.update_email_token = nil
    self.email = email
    save!
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
