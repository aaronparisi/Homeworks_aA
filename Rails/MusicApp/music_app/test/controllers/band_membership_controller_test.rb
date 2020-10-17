require 'test_helper'

class BandMembershipControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get band_membership_new_url
    assert_response :success
  end

  test "should get create" do
    get band_membership_create_url
    assert_response :success
  end

  test "should get destroy" do
    get band_membership_destroy_url
    assert_response :success
  end

end
