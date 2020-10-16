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
require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
