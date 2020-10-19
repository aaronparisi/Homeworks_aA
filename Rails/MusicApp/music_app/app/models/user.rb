# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  authenticated   :boolean          default(FALSE)
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
  validates :username, presence: true, uniqueness: true
  validates :password, length: { minimum: 4 }, allow_nil: true
  validates :email, presence: true
  validates :authenticated, inclusion: [true, false]
  # validates :session_token, presence: true
  validate :passwords_match
  has_secure_password

  after_initialize :set_defaults
  after_initialize :ensure_session_token

  has_many :band_memberships, class_name: :BandMembership, foreign_key: :member_id, dependent: :destroy
  has_many :bands, through: :band_memberships

  has_many :made_likes, class_name: :Like, foreign_key: :liker_id, dependent: :destroy

  has_many :liked_bands, through: :made_likes, source: :likeable, source_type: :Band
  has_many :liked_albums, through: :made_likes, source: :likeable, source_type: :Album
  has_many :liked_tracks, through: :made_likes, source: :likeable, source_type: :Track

  def self.find_by_credentials(email, password)
    ret = User.find_by(email: email)
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
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def passwords_match
    self.password == self.password_confirmation
  end
  
  def reset_session_token
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end
  
  def in_the_band?(band_or_album)
    if band_or_album.class == Album
      band = band_or_album.band
    else
      band = band_or_album
    end

    band.has_member?(self)
  end
  
  def authenticated?
    self.authenticated
  end
  
  private
  
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
  
  def set_defaults
    self.authenticated ||= false
  end
  
end
