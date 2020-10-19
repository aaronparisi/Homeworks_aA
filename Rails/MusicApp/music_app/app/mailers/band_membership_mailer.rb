class BandMembershipMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.band_membership_mailer.invite.subject
  #
  def invite(band, user)
    @greeting = "Hi"
    @url = "http://localhost:3000/bands/#{band.id}/users/#{user.id}/join"

    mail to: user.email, subject: "You were invited to join a band"
  end
end
