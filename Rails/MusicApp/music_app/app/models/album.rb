# == Schema Information
#
# Table name: albums
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  band_id    :bigint
#
# Indexes
#
#  index_albums_on_band_id  (band_id)
#
# Foreign Keys
#
#  fk_rails_...  (band_id => bands.id)
#
class Album < ApplicationRecord
  validates :name, presence: true

  belongs_to :band
  has_many :tracks, dependent: :destroy
end
