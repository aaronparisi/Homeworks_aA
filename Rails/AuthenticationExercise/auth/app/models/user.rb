class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  has_secure_password
  # notice that the user provides a password, but we will SAVE
  # the password_digest to the database

  def password=(pw)
    # sets the users password_digest from the plaintext password passed in
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(guess)
    # returns true if the guess equal the user's password
    # notice we cannot compare guess to self.password,
    # since we do not store password
    # we have to use BCrypt's is_password on a BCrypt version of the
    # digested STRING stored in the database
    BCrypt::Password.new(self.password_digest).is_password?(guess)
  end
  
end
