class BandMembershipsController < ApplicationController
  before_action :require_band_membership, only: [:invite, :new, :destroy]
  # before_action :require_this_logged_in, only: [:destroy]

  def new
    @band = Band.find(params[:band_id])
    # @membership = BandMembership.new
  end

  def invite
    @band = Band.find(params[:band_id])
    @user = User.find_by(email: params[:email])
    BandMembershipMailer.invite(@band, @user).deliver_later
    redirect_to band_path(@band), notice: 'invite sent'
  end

  def create
    @to_add = User.find(params[:user_id])
    if @to_add.nil?
      # user does not exist
      redirect_to band_path(band_id: params[:band_id]), notice: "no user with that e mail"
    else
      @band_membership = BandMembership.new(
        band_id: params[:id],
        member_id: @to_add.id
      )
      
      if @band_membership.save
        redirect_to band_path(@band_membership.band), notice: "member added"
      else
        render :new
      end
    end
  end

  def destroy
    @to_destroy = BandMembership.find_by_credentials(
      params[:band_id].to_i,
      params[:member_id].to_i
    )
    
    if @to_destroy.nil?
      redirect_to root_path, notice: "this should not happen, something is wrong"
    else
      if @to_destroy.destroy
        redirect_to root_path, notice: "left band"
      else
        redirect_to root_path, notice: "didn't leave band"
      end
    end
  end

  private

  def band_membership_params
    params.permit(:band_id, :email)
  end
  
end
