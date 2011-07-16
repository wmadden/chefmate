class Dishes::IngredientsController < ApplicationController

  def new
    dish = Dish.find( params['dish_id'] )
    @ingredient = dish.ingredients.new
  end

  def create
    dish = Dish.find( params['dish_id'] )
    @ingredient = dish.ingredients.new( params['ingredient'] )

    if @ingredient.save
      flash[:success] = "Ingredient added successfully"
      redirect_to( dish_path(dish) )
    else
      flash[:error] = "Failed to add ingredient"
      render 'new'
    end
  end

end