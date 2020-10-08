class CommentsController < ApplicationController

  def index
    if params[:user_id]    
      # we want a user's comments
      render json: User.find(params[:user_id]).authored_comments
      # why does this param get passed as :user_id?????
    elsif params[:artwork_id]
      render json: Artwork.find(params[:artwork_id]).comments
    else

    end
  end

  def create
    comment = Comment.new(comments_params)

    if comment.save
      render json: comment.to_json
    else
      render json: comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find(params[:id])

    if comment.destroy
      render json: comment.to_json
    else
      ##
    end
  end
  
  private

  def comments_params
    params.require(:comment).permit(:body, :author_id, :artwork_id)
  end
end
