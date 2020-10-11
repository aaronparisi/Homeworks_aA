# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  validates :username, presence: true

  has_many :artworks, class_name: :Artwork, foreign_key: :artist_id, dependent: :destroy

  has_many :artwork_shares, class_name: :ArtworkShare, foreign_key: :viewer_id, dependent: :destroy
  has_many :viewed_pieces, through: :artwork_shares, source: :artwork

  has_many :authored_comments, class_name: :Comment, foreign_key: :author_id, dependent: :destroy
  # pieces that this user has commented on 
  has_many :pieces_critiqued, through: :authored_comments, source: :artwork

  has_many :made_likes, class_name: :Like, foreign_key: :user_id, dependent: :destroy

  # works that this user has liked
  has_many :artworks_liked, through: :made_likes, source: :likeable, source_type: 'Artwork'
  # comments that this user has liked
  has_many :comments_liked, through: :made_likes, source: :likeable, source_type: 'Comment'

  # fans

  # works BY this user which have been liked
  has_many :liked_artworks, through: :artworks, source: :likes
  # comments BY this user which have been liked
  has_many :liked_comments, through: :comments, source: :comments

  # 1. the pieces on which a user commented?
  # 2. the pieces a user created which have been commented on?

  # collections
  has_many :collections, foreign_key: :artist_id
  has_many :collected_pieces, through: :collections, source: :artworks
end

# todo decide what kind of routes I want