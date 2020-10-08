class User < ApplicationRecord
  validates :username, presence: true

  has_many :artworks, class_name: :Artwork, foreign_key: :artist_id, dependent: :destroy

  has_many :artwork_shares, class_name: :ArtworkShare, foreign_key: :viewer_id, dependent: :destroy
  has_many :viewed_pieces, through: :artwork_shares, source: :artwork

  has_many :authored_comments, foreign_key: :author_id, dependent: :destroy
  has_many :pieces_critiqued, through: :comments, source: :artwork

  # 1. how do I go to a list of the pieces on which a user commented?
  # 2. how do I go to a list of the pieces a user created which have been commented on?
end
