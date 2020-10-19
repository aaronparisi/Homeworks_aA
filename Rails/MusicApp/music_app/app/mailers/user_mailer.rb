class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signed_up.subject
  #

  default from: 'Aaron Parisi <aarons_coding_stuff@gmail.com>'

  def signed_up(user)
    @user = user.username
    @greeting = "Hi"
    @url = "http://localhost:3000/users/#{user.id}/authenticate"

    mail to: user.email, subject: "You signed up!"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.invited.subject
  #
  def invited
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
