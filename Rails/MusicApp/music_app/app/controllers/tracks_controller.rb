class TracksController < ApplicationController
  before_action :find_track, only: [:show, :edit, :update, :destroy]
  before_action :require_band_membership, only: [:new, :create, :edit, :update, :destroy]

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
  
  def like
    @track = Track.find(params[:track_id])
    @like = @track.likes.build(likeable_type: "Track", liker_id: current_user.id)

    if @like.save
      redirect_to album_path(@track.album), notice: "successfully liked"
    else
      redirect_to album_path(@track.album), notice: "like failed"
    end
  end
  
  def unlike
    @track = Track.find(params[:track_id])
    @like = Like.where(likeable_type: "Track", likeable_id: @track.id, liker_id: current_user.id).first

    redirect_to album_path(@track.album), notice: "something is wrong, such a like should have existed" if @like.nil?
    if @like.destroy
      redirect_to album_path(@track.album), notice: "successfully unliked"
    else
      redirect_to album_path(@track.album), notice: "unlike failed"
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
