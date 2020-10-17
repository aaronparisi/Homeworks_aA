class TracksController < ApplicationController
  before_action :find_track, except: [:index, :new, :create]

  def index
    @track = Album.where(album_id: params[:album_id])
    @album = Album.find(params[:album_id])
  end
  
  def show
    
  end
  
  def new
    @track = Track.new
    @album = Album.find(params[:album_id])
  end
  
  def create
    @track = Track.new(track_params)
    @track.album_id ||= params[:album_id]

    if @track.save
      redirect_to album_path(@track.album)# , notice: "track created"
    else
      render :new
    end
  end
  
  def edit
    @album = Album.find(params[:album_id])
  end
  
  def update
    if @track.save(track_params)
      redirect_to album_path(@track.album), notioce: "track updated"
    else
      render :edit
    end
  end
  
  def destroy
    if @track.destroy
      redirect_to root_path, notice: "track destroyed"
    else
      redirect_to root_path, notice: "track not destroyed"
    end
  end
  
  private

  def find_track
    @track = Track.find(params[:id])    
  end
  
  def track_params
    params.require(:track).permit(:name)
  end
end
