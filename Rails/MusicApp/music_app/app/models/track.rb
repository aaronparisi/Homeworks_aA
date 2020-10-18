# == Schema Information
#
# Table name: tracks
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  album_id   :bigint
#
# Indexes
#
#  index_tracks_on_album_id  (album_id)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#
class Track < ApplicationRecord
  validates :name, presence: true

  belongs_to :album

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :fans, through: :likes, source: :liker
end
