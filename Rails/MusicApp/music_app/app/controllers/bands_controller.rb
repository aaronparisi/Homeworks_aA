class BandsController < ApplicationController
  before_action :find_band, only: [:show, :edit, :update, :destroy]
  before_action :require_any_logged_in
  before_action :require_band_membership, only: [:edit, :update, :destroy]

  def index
    if params[:user_id]
      # index page for bands a user's bands
      @bands = User.find(params[:user_id]).bands
    else
      @bands = Band.all
    end
  end
  
  def show
    @albums = @band.albums
  end
  
  def new
    @band = Band.new
    @user = current_user
  end
  
  def create
    @band = Band.new(band_params)
    
    if @band.save
      @band.band_memberships.build(
        band_id: @band.id,
        member_id: params[:user_id],
        instrument: params[:instrument]
      ).save
      redirect_to band_path(@band), notice: "band created"
    else
      render :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @band.save(band_params)
      redirect_to band_path(@band), notioce: "band updated"
    else
      render :edit
    end
  end
  
  def destroy
    if @band.destroy
      redirect_to root_path, notice: "band destroyed"
    else
      redirect_to root_path, notice: "band not destroyed"
    end
  end

  def like
    @band = Band.find(params[:band_id])
    @like = @band.likes.build(likeable_type: "Band", liker_id: current_user.id)

    if @like.save
      redirect_to band_path(@band), notice: "successfully liked"
    else
      redirect_to band_path(@band), notice: "like failed"
    end
  end
  
  def unlike
    @band = Band.find(params[:band_id])
    @like = Like.where(likeable_type: "Band", likeable_id: @band.id, liker_id: current_user.id).first

    redirect_to band_path(@band), notice: "something is wrong, such a like should have existed" if @like.nil?
    if @like.destroy
      redirect_to band_path(@band), notice: "successfully unliked"
    else
      redirect_to band_path(@band), notice: "unlike failed"
    end
  end
  
  private

  def find_band
    @band = Band.find(params[:id])    
  end
  
  def band_params
    params.require(:band).permit(:name, :instrument)
  end
  
end
