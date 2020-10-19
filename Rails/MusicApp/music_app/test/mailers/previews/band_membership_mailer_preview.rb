# Preview all emails at http://localhost:3000/rails/mailers/band_membership_mailer
class BandMembershipMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/band_membership_mailer/invite
  def invite
    BandMembershipMailer.invite
  end

end
