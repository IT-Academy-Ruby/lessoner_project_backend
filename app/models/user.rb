# frozen_string_literal: true

class User < ApplicationRecord
  paginates_per MAX_ITEMS_PER_PAGE

  enum :gender, %i[male female other]
  validates :gender, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: %i[google_oauth2 facebook]

  validates :name, presence: true, length: { in: 3..50 }, format: { with: /[a-z0-9]+/i }, uniqueness: true
  validates :email, presence: true,
                    format: { with: /\A[a-zA-Z0-9!#$%&'*+\-\/=?^_`{|}~.]+@[a-z0-9\-.]*\z/ }
  validate :email_dots, if: -> { email.present? }

  validate :password_special_character, if: -> { password.present? }
  validates :password, presence: true, length: { in: 6..256 },
                       format: { with: /[a-z0-9!#$%&'*+\-\/=?^_`{|}~]+/i }
  validates :phone, format: { with: /\A\+/ }, if: -> { phone.present? }

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


  # 
  def email_dots
    login = email.scan(/\S+@/).join
    if login.count('.')>1 || login[0]=='.' || login[-2]=='.'
      errors.add(:email, 'has too many dots')
    end
  end

  #
  def password_special_character
    if password.count("!#$%&'*+\-\/=?^_`{|}~")==0
      errors.add(:password, 'must contain at least 1 special character')
    end
  end
end
