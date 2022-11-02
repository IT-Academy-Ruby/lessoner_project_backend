# frozen_string_literal: true

class User < ApplicationRecord
  paginates_per MAX_ITEMS_PER_PAGE

  enum :gender, %i[male female other]
  validates :gender, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: %i[google_oauth2 facebook]
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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid

      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.avatar_url = auth.info.image
    end
  end

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

  def generate_password_token!
    self.password_reset_token = generate_token
    self.password_reset_sent_at = Time.now.utc
    save!(validate: false)
  end

  def password_token_valid?
    (self.password_reset_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.password_reset_token = nil
    self.password = password
    save!
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end
end
