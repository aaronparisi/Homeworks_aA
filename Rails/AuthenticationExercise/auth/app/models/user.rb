class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true

  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :password_digest, presence: { message: 'Password can not be blank' }
  has_secure_password
  # notice that the user provides a password, but we will SAVE
  # the password_digest to the database
  validates :session_token, presence: true
  after_initialize :ensure_session_token
  
  def self.find_by_credentials(username, password)
    # ret = self.where(username: username, password: password)
    # this does not work because no actual password is saved in the db
    # we would need to get a User instance to call User#is_password?
    user = User.find_by(username: username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end
  
  def password=(pw)
    # sets the users password_digest from the plaintext password passed in
    # notice that this overrides the usual behavior (setting a password in the db)
    # and instead uses the given info to populate the password_digest column
    @password = pw
    # @password is an instance variable, NOT an instance attribute (self.password_dig)
    # this allows us to validate the length of the given password
    # but we do NOT save this in the database
    self.password_digest = BCrypt::Password.create(pw)
  end
  
  def password
    @password
  end
  
  def is_password?(guess)
    # returns true if the guess equal the user's password
    # notice we cannot compare guess to self.password,
    # since we do not store password
    # we have to use BCrypt's is_password on a BCrypt version of the
    # digested STRING stored in the database
    BCrypt::Password.new(self.password_digest).is_password?(guess)
  end

  def reset_session_token
    # for when we need a new session token for this user
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end
  
  private
  
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
  
end
