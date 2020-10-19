# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  authenticated   :boolean          default(FALSE)
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email)
#  index_users_on_username  (username)
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
