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
require 'test_helper'

class CollectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
