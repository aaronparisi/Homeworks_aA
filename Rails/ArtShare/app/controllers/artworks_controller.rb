class ArtworksController < ApplicationController

  def index
    user = User.find(params[:user_id])
    createdWorks = user.artworks
    viewedWorks = user.viewed_pieces
    retString = [
      { created: createdWorks },
      { viewed: viewedWorks }
    ]

    render json: retString
  end
  
  def create
    artwork = Artwork.new(artwork_params)

    if artwork.save
      render json: artwork.to_json
    else
      render json: artwork.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def update
    artwork = Artwork.find(params[:id])

    if artwork.save(artwork_params)
      render json: artwork.to_json
    else
      render json: artwork.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def destroy
    artwork = Artwork.find(params[:id])

    if artwork.destroy
      render json: artwork.to_json
    else
      
    end
  end
  
  private

  def artwork_params
    params.require(:artwork).permit(:title, :image_url, :artist_id)
  end
  
end
