# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  artwork_id :bigint
#  author_id  :bigint
#
# Indexes
#
#  index_comments_on_artwork_id  (artwork_id)
#  index_comments_on_author_id   (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (artwork_id => artworks.id)
#  fk_rails_...  (author_id => users.id)
#
class Comment < ApplicationRecord
  validates :body, :author_id, :artwork_id, presence: true
  validate :creator_cannot_critique

  belongs_to :author, class_name: :User, foreign_key: :author_id, primary_key: :id
  belongs_to :artwork

  has_many :likes, as: :likeable

  def creator_cannot_critique
    if Artwork.find(artwork_id).artist_id == author_id
      errors.add(:author, "Cannot comment on own work!")
    end
  end
  
end
