class Dishes::IngredientsController < ApplicationController

  def new
    @dish = Dish.find( params['dish_id'] )
    @ingredient = @dish.ingredients.new( :component => Component.new )
  end

  def create
    dish = Dish.find( params['dish_id'] )

    component_name = params['ingredient'].delete( 'name' )
    component = Component.find_by_name( component_name )

    @ingredient = dish.ingredients.new( params['ingredient'] )

    if component
      @ingredient.component = component
    else
      @ingredient.component = Component.create!( :name => component_name )
    end

    if @ingredient.save
      flash[:success] = "Ingredient added successfully"
      redirect_to( dish_path(dish) )
    else
      flash[:error] = "Failed to add ingredient"
      render 'new'
    end
  end

end