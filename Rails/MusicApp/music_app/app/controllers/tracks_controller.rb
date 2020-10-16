class TracksController < ApplicationController
  before_action :find_track, except: [:index, :new, :create]

  def index
    @track = Album.all
  end
  
  def show
    
  end
  
  def new
    @track = Album.new
  end
  
  def create
    @track = Album.new(track_params)

    if @track.save
      redirect_to track_path(@track), notice: "track created"
    else
      render :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @track.save(track_params)
      redirect_to track_path(@track), notioce: "track updated"
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
