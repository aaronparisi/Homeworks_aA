# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  password_digest :string           not null
#  session_token   :string
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username)
#
class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 2 }, allow_nil: true
  validates :password_digest, presence: true, message: "Password can't be blank"
  validates :session_token, presence: true
  validate :passwords_match
  has_secure_password

  after_initialize :ensure_session_token

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.find_by_credentials(username, password)
    ret = User.find_by(username: username)
    return nil if ret.nil?
    ret.is_password?(password) ? ret : nil
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end
  
  def password
    @password
  end

  def reset_session_token
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
    # we return this for who??
  end

  def passwords_match
    self.password == self.password_confirmation  
  end  
  
  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end
  
  private
  
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  
end
