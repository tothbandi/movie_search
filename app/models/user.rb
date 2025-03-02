class User < ApplicationRecord
  has_secure_password

  encrypts :token

  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
