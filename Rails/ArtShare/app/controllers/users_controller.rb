class UsersController < ApplicationController

  def index
    render json: User.all.to_json
  end

  def show
    render json: User.find(params[:id]).to_json
  end
  
  def create
    user = User.new(user_params)

    if user.save
      render json: user.to_json
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    
    if user.save(user_params)
      render json: user.to_json
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  
  def destroy
    user = User.find(params[:id])
    
    if user.destroy
      render json: user.to_json
    else
      
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:username)
  end
  
end
