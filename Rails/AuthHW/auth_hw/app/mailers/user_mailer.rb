class UserMailer < ApplicationMailer
  default from: 'aarons.coding.stuff@gmail.com'

  def welcome_email(user)
    # sends welcome e mail
    @user = user
    @url = 'localhost:3000/login'
    mail(to: user.email, subject: "Welcome to localhost!")
  end

  def reminder_email(user)
    
  end
  
  
end
