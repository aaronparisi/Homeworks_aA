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
require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
