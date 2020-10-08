class Comment < ApplicationRecord
  validates :body, :author_id, :artwork_id, presence: true
  validate :creator_cannot_critique

  belongs_to :author, class_name: :User, foreign_key: :author_id, primary_key: :id
  belongs_to :artwork

  def creator_cannot_critique
    if Artwork.find(artwork_id).artist_id == author_id
      errors.add(:author, "Cannot comment on own work!")
    end
  end
  
end
