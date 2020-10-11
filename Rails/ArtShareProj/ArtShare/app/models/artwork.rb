# == Schema Information
#
# Table name: artworks
#
#  id         :bigint           not null, primary key
#  image_url  :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  artist_id  :bigint
#
# Indexes
#
#  index_artworks_on_artist_id            (artist_id)
#  index_artworks_on_title_and_artist_id  (title,artist_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (artist_id => users.id)
#
class Artwork < ApplicationRecord
  validates :title, :image_url, :artist_id, presence: true
  validates :title, uniqueness: { scope: :artist_id }

  belongs_to :artist, class_name: :User, foreign_key: :artist_id
  
  has_many :artwork_shares, class_name: :ArtworkShare, foreign_key: :artwork_id, dependent: :destroy
  has_many :viewers, through: :artwork_shares

  has_many :comments, dependent: :destroy
  has_many :critics, through: :comments, source: :author

  has_many :likes, as: :likeable
  has_many :fans, through: :likes, source: :user

  has_many :collection_assignments
  has_many :collections, through: :collection_assignments

end
