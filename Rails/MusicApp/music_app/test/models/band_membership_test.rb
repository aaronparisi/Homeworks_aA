# == Schema Information
#
# Table name: band_memberships
#
#  id         :bigint           not null, primary key
#  instrument :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  band_id    :bigint
#  member_id  :bigint
#
# Indexes
#
#  index_band_memberships_on_band_id    (band_id)
#  index_band_memberships_on_member_id  (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (band_id => bands.id)
#  fk_rails_...  (member_id => users.id)
#
require 'test_helper'

class BandMembershipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
