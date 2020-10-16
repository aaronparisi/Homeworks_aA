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
  validates :session_token, presence: true
  has_secure_password

  def self.find_by_credentials
    
  end

  def reset_session_token
    
  end

  private
  
  def ensure_session_token
    
  end
  
end
