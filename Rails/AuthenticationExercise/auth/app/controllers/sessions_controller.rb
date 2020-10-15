class SessionsController < ApplicationController

  def new
    # to login screen
    # @session = Session.new
    # notice there is NO SESSION MODEL
    # the FORM is just a form, not attached to a model
  end

  def create
    # log user in, create session
    @user = User.find_by_credentials(
      params[:username],
      params[:password]
    )
    if @user
      # go ahead and create a new session
      # we outsource the logic of creating the session to 
      # the application level??????
      login!(@user)
      redirect_to user_path(@user)
    else
      # we did not find a user with those credentials
      redirect_to login_path, notice: "Wrong credentials"
    end
  end
  
  def destroy
    logout!
    redirect_to root_path, notice: "Signed out!"
  end

  private

  def session_params
    params.require(:session).permit(:usrename, :password)
  end
  
  
end
