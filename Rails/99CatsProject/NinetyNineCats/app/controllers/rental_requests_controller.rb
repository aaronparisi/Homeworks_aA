class RentalRequestsController < ApplicationController

  def index
    if params[:cat_id]
      @rentals = RentalRequest.where(cat_id: params[:cat_id])
      @subject = Cat.find(params[:cat_id])
    elsif params[:user_id]
      @rentals = RentalRequest.where(user_id: params[:user_id])
      @subject = User.find(params[:user_id])
    else
      redirect_to root_path, notice: "Something's wrong"
    end
  end

  def new
    if nobody_logged_in? || making_request_for_wrong_user?
      redirect_to login_path, notice: "You must be logged in to rent a cat!"
    end

    @rq = RentalRequest.new
    @cat_id = params[:cat_id] # might be nil
    @user_id = session[:user_id]
  end
  
  def create
    @rq = RentalRequest.new(request_params)

    if @rq.save
      redirect_to cat_path(id: @rq.cat_id), notice: "Request submitted"
    else
      render 'new'
    end
  end

  def approve
    @toApprove = RentalRequest.find(params[:rental_request_id])
    @toApprove.approve!

    redirect_to cat_path(id: @toApprove.cat_id)
  end
  
  def deny
    @toDeny = RentalRequest.find(params[:rental_request_id])
    @toDeny.deny!

    redirect_to cat_path(id: @toDeny.cat_id)
  end
  
  private

  def request_params
    params.require(:rental_request).permit(:user_id, :cat_id, :start_date, :end_date)
  end

  def nobody_logged_in?
    # returns true if nobody is logged in
    session[:user_id].nil?
  end

  def making_request_for_wrong_user?
    params[:user_id] && (params[:user_id].to_i != session[:user_id])
  end
  
  
  
end
