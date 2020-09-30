# == Schema Information
#
# Table name: votes
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  shortened_url_id :bigint
#  user_id          :bigint
#
# Indexes
#
#  index_votes_on_shortened_url_id  (shortened_url_id)
#  index_votes_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (shortened_url_id => shortened_urls.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
