class BandMembershipsController < ApplicationController
  def new
    @band = Band.find(params[:band_id])
    # @membership = BandMembership.new
  end

  def create
    @to_add = User.find_by(email: params[:email])
    if @to_add.nil?
      # user does not exist
      redirect_to band_path(band_id: params[:band_id]), notice: "no user with that e mail"
    else
      @band_membership = BandMembership.new(
        band_id: params[:band_id],
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
  end

  private

  def band_membership_params
    params.permit(:band_id, :email)
  end
  
end
