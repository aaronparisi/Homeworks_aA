class BandsController < ApplicationController
  before_action :find_band, except: [:index, :new, :create]
  before_action :require_any_logged_in

  def index
    if params[:usr_id]
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
      )
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
  
  private

  def find_band
    @band = Band.find(params[:id])    
  end
  
  def band_params
    params.require(:band).permit(:name, :instrument)
  end
  
end
