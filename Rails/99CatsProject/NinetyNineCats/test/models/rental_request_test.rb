# == Schema Information
#
# Table name: rental_requests
#
#  id         :bigint           not null, primary key
#  end_date   :date             not null
#  start_date :date             not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cat_id     :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_rental_requests_on_cat_id   (cat_id)
#  index_rental_requests_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (cat_id => cats.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class RentalRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
