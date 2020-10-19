require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "signed_up" do
    mail = UserMailer.signed_up
    assert_equal "Signed up", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "invited" do
    mail = UserMailer.invited
    assert_equal "Invited", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
