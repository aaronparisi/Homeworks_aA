class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :require_any_logged_in, except: [:index, :new, :create]
  before_action :require_this_logged_in, only: [:show, :edit, :update, :destroy]
  before_action :require_logged_out, only: [:new, :create]

  def welcome
    if current_user
      redirect_to user_path(current_user)
    else
      redirect_to login_path
    end
  end

  def index
    if params[:band_id]
      @band = Band.find(params[:band_id])
      @users = @band.members
    else
      @users = User.all
    end
  end

  def show

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      login!(@user)
      # session[:session_token] = @user.session_token <= done in login!()
      redirect_to root_path, notice: "logged in!"
    else
      redirect_to new_user_path, notice: "something is wrong"
    end
  end

  def edit

  end

  def update
    if @user.save(user_params)
      redirect_to root_path, notice: "edited successfully"
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to root_path, notice: "destroyed user"
    else
      redirect_to root_path, notice: "user not destroyed"
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
  
end