class UsersController < ApplicationController
  before_action :current_user
  before_action :require_current_user!, except: [:new, :create]
  before_action :require_this_user!, only: [:show]
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to user_path(@user), notice: "User saved"
      # render json: @user
    else
      render :new, notice: "User not saved"
      # render json: @user.errors.full_messages
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
  
end
