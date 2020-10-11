# == Schema Information
#
# Table name: collections
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  artist_id  :bigint
#
# Indexes
#
#  index_collections_on_artist_id  (artist_id)
#
# Foreign Keys
#
#  fk_rails_...  (artist_id => users.id)
#
class Collection < ApplicationRecord
  belongs_to :artist, class_name: :User, foreign_key: :artist_id
  has_many :collection_assignments
  has_many :artworks, through: :collection_assignments
end
