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
    if session[:user_id]
      @rq = RentalRequest.new
      @cat_id = params[:cat_id]
      @user_id = session[:user_id]
    else
      redirect_to login_path, notice: "You must be logged in to rent a cat!"
    end
  end
  
  def create
    @rq = RentalRequest.new(request_params)

    if @rq.save
      redirect_to cat_path(id: @rq.cat_id), notice: "Request submitted"
    else
      render 'new'
    end
  end
  
  private

  def request_params
    params.require(:rental_request).permit(:user_id, :cat_id, :start_date, :end_date)
  end
  
end
