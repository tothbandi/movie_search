class User < ApplicationRecord
  has_secure_password

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  encrypts :api_token

  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email address" }
  validates :password, presence: true, confirmation: true

  has_many :sessions, dependent: :destroy
end
