class SessionsController < ApplicationController

  def new
    if User.all.empty?
      redirect_to new_user_path, notice: "create a user first, silly"
    end
  end

  def create
    @user = User.find_by_credentials(
      params[:username],
      params[:password]
    )

    if @user
      # success, log them in
      login!(@user)
      redirect_to root_path, notice: "Logged in!"
    else
      # failure, no user found
      render :new, notice: "Bad credentials"
    end
  end

  def destroy
    logout!
    redirect_to root_path, notice: "Logged out!"
  end
end
