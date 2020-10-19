# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/signed_up
  def signed_up
    UserMailer.signed_up
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/invited
  def invited
    UserMailer.invited
  end

end
