class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all  
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
      redirect_to user_path(@user), notice: "user created"
    else
      # redirect_to new_user_path, notice: "there are #{@user.errors.full_messages.length} errors"
      # when I do the above, it says there are 2 errors, which is what I want
      render :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @user.save(user_params)
      redirect_to user_path(@user), notice: "User updated"
    else
      render :edit, notice: "unable to update user"
    end
  end
  
  def destroy
    if @user.destroy
      redirect_to root_path, notice: "deleted user"
    else
      redirect_to root_path, notice: "did not delete user"
    end
  end
  
  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
  
end
