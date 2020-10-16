# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email)
#  index_users_on_username  (username)
#
class User < ApplicationRecord
  validates :username, :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 4 }, allow_nil: true
  # validates :session_token, presence: true
  validate :passwords_match
  has_secure_password

  after_initialize :ensure_session_token

  def self.find_by_credentials(email, password)
    ret = User.where(email: email)
    return nil if ret.nil?

    ret.is_password?(password) ? ret : nil
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end
  
  def password
    @password
  end

  def is_password?(password)
    BCrypt::Password.new(ret.password_digest).is_password?(password)
  end

  def passwords_match
    self.password == self.password_confirmation
  end
  
  def reset_session_token
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  private
  
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
  
end
