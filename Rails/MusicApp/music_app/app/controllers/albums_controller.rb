class AlbumsController < ApplicationController
  before_action :find_album, except: [:index, :new, :create]
  before_action :require_band_membership, except: [:index, :show]

  def index
    @album = Album.where(band_id: params[:band_id])
    @band = Band.find(params[:band_id])
  end
  
  def show
    @tracks = @album.tracks
  end
  
  def new
    @album = Album.new
    @band = Band.find(params[:band_id])
  end
  
  def create
    @album = Album.new(album_params)
    @album.band_id = params[:band_id]

    if @album.save
      redirect_to album_path(@album), notice: "album created"
    else
      render :new
    end
  end
  
  def edit
    @band = Band.find(params[:band_id])
  end
  
  def update
    if @album.save(album_params)
      redirect_to album_path(@album), notioce: "album updated"
    else
      render :edit
    end
  end
  
  def destroy
    if @album.destroy
      redirect_to root_path, notice: "album destroyed"
    else
      redirect_to root_path, notice: "album not destroyed"
    end
  end
  
  private

  def find_album
    @album = Album.find(params[:id])    
  end
  
  def album_params
    params.require(:album).permit(:name)
  end
  
end
