class SessionsController < ApplicationController

  def new
    redirect_to new_user_path if User.none?
  end
  
  def create
    user = User.find_by(name: params[:name])
    if user.nil? || user.email != params[:email]
      redirect_to login_url, notice: "No user with those credentials exists"
    else
      session[:user_id] = user.id
      redirect_to root_path, notice: "Successfully Logged In"
    end
  end
  
  def destroy
    session[:user_id] = nil

    redirect_to root_path, notice: "Successfully Logged Out"
  end
  
end
