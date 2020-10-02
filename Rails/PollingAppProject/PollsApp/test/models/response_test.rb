# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  answer_choice_id :integer
#  respondent_id    :integer
#
# Indexes
#
#  index_responses_on_answer_choice_id  (answer_choice_id)
#  index_responses_on_respondent_id     (respondent_id)
#
require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
