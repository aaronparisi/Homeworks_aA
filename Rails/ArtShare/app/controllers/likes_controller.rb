class LikesController < ApplicationController

  def index
    if params[:user_id]    
      # we want a user's comments
      render json: Like.find(params[:user_id]).likes
      # why does this param get passed as :user_id?????
    elsif params[:artwork_id]
      render json: Artwork.find(params[:artwork_id]).likes
    else

    end
  end

  def create
    like = Like.new(like_params)

    if like.save
      render json: like.to_json
    else
      render json: like.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def destroy
    like = Like.find(params[:id])

    if like.destroy
      render json: like.to_json
    else
      # something went wrong
    end
  end
  
  private

  def like_params
    params.require(:like).permit(:likeable_id, :user_id)
  end
  
end
