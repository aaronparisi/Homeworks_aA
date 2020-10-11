# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  artwork_id :bigint
#  author_id  :bigint
#
# Indexes
#
#  index_comments_on_artwork_id  (artwork_id)
#  index_comments_on_author_id   (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (artwork_id => artworks.id)
#  fk_rails_...  (author_id => users.id)
#
require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
