class User < ApplicationRecord
  has_secure_password

  has_many :invents

  validates :username, :first_name, :last_name, presence: true
  validates :username, :api_key, uniqueness: true
end
