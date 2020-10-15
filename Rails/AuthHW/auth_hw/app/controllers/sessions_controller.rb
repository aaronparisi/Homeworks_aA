class SessionsController < ApplicationController

  def new
    
  end
  
  def create
    @user = User.find_by_credentials(
      params[:username],
      params[:password]
    )

    if @user
      login!(@user)
      redirect_to user_path(@user)
    else
      redirect_to login_path, notice: "bad credentials"
    end
  end
  
  def destroy
    logout!
    redirect_to root_path, notice: "logged out"  
  end  
  
end
