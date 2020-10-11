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
require 'test_helper'

class ArtworkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
