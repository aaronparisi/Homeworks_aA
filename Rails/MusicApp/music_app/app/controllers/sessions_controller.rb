class SessionsController < ApplicationController

  def new
    if User.all.empty?
      redirect_to new_user_path, notice: "create a user first, silly"
    end

    redirect_to users_path, notice: "logout first" if current_user
  end

  def create
    @user = User.find_by_credentials(
      params[:email],
      params[:password]
    )
    
    render :new, notice: "Bad credentials" if @user.nil?

    if @user.authenticated?
      # success, log them in
      login!(@user)
      redirect_to root_path, notice: "Logged in!"
    else
      UserMailer.signed_up(@user).deliver_later
      redirect_to awaiting_auth_user_path(@user), notice: "must authenticate before signing in, check your e mail"
    end
  end

  def destroy
    logout!
    redirect_to login_path, notice: "Logged out!"
  end
end
