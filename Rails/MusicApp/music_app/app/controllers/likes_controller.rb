class LikesController < ApplicationController
  before_action :require_any_logged_in

  def create
    @like = Like.new(
      # band_id: params[:band_id]
      liker_id: current_user.id
    )

    if params[:band_id]
      @like.likeable_id = params[:band_id]
      @like.likeable_type = "Band"
    elsif params[:album_id]
      @like.likeable_id = params[:album_id]
      @like.likeable_type = "Album"
    else
      @like.likeable_id = params[:track_id]
      @like.likeable_type = "Track"
    end

    if @like.save
      # redirect_to URI.split[0..-2].join, notice: "successfully liked"
      redirect_to build_like_path, notice: "successfully liked"
    else
      # redirect_to URI.split[0..-2].join, notice: "like unsucessful"
      redirect_to build_like_path, notice: "like unsucessful"
    end
  end
  
  def destroy
    
  end
  
end
