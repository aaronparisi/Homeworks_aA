class Artwork < ApplicationRecord
  validates :title, :image_url, :artist_id, presence: true
  validates :title, uniqueness: { scope: :artist_id }

  belongs_to :artist, class_name: :User, foreign_key: :artist_id
  
  has_many :artwork_shares, class_name: :ArtworkShare, foreign_key: :artwork_id, dependent: :destroy
  has_many :viewers, through: :artwork_shares

  has_many :comments, dependent: :destroy
  has_many :critics, through: :comments, source: :author

end
