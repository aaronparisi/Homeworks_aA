class CatsController < ApplicationController
  before_action :find_cat, only: [:show, :edit, :update, :destroy]

  def index
    @cats = Cat.all
  end

  def show
    @rentals = RentalRequest.where(cat_id: @cat.id)
  end

  def new
    @cat = Cat.new    
  end

  def create
    @cat = Cat.new(cat_params)

    if @cat.save
      redirect_to cat_path(@cat)
    else
      render :new
    end
  end

  def edit
    
  end

  def update
    if @cat.save(cat_params)
      redirect_to cat_path(@cat)
    else
      render :edit
    end
  end
  
  def destroy
    if @cat.destroy
      redirect_to root_path, notice: "Cat successfully destroyed"
    else
      redirect_to cat_path(@cat)
    end
  end
  
  private
  
  def find_cat
    @cat = Cat.find(params[:id])
  end
  
  def cat_params
    params.require(:cat).permit(:name, :color, :birth_date, :sex, :description)
  end
  
end
