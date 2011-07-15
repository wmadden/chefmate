class DishesController < ApplicationController

  def index
    @dishes = Dish.find :all
  end

  def new
    @dish = Dish.new
  end

  def create
    @dish = Dish.new( params['dish'] )

    if @dish.save
      flash[:success] = "Dish created"
      redirect_to dish_path(@dish)
    else
      flash[:error] = "Failed to create dish"
      render 'new'
    end
  end

  def show
    @dish = Dish.find( params['id'] )
  end

  def edit
    @dish = Dish.find( params['id'] )
  end

  def update
    @dish = Dish.find( params['id'] )

    if @dish.update_attributes( params['dish'] )
      flash[:success] = "Dish updated"
      redirect_to dish_path(@dish)
    else
      flash[:error] = "Failed to update dish"
      render 'edit'
    end
  end

end