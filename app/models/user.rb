class User < ApplicationRecord
  has_secure_password
  validates_presence_of :username, :email, :password_digest
  validates :password, :length => { :minimum => 7 }
  validates_confirmation_of :password
  validates_uniqueness_of :email
end
