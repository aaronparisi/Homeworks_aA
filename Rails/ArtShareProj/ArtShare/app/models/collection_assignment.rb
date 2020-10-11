# == Schema Information
#
# Table name: collection_assignments
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  artwork_id    :bigint
#  collection_id :bigint
#
# Indexes
#
#  index_collection_assignments_on_artwork_id     (artwork_id)
#  index_collection_assignments_on_collection_id  (collection_id)
#
# Foreign Keys
#
#  fk_rails_...  (artwork_id => artworks.id)
#  fk_rails_...  (collection_id => collections.id)
#
class CollectionAssignment < ApplicationRecord
  validates :artwork_id, uniqueness: :true
  belongs_to :collection
  belongs_to :artwork
end
