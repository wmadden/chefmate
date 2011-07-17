class Recipes::IngredientsController < ApplicationController

  def new
    @recipe = Recipe.find( params['recipe_id'] )
    @ingredient = @recipe.ingredients.new( :component => Component.new )
  end

  def create
    recipe = Recipe.find( params['recipe_id'] )

    component_name = params['ingredient'].delete( 'name' )
    component = Component.find_by_name( component_name )

    @ingredient = recipe.ingredients.new( params['ingredient'] )

    if component
      @ingredient.component = component
    else
      @ingredient.component = Component.create!( :name => component_name )
    end

    if @ingredient.save
      flash[:success] = "Ingredient added successfully"
      redirect_to( recipe_path(recipe) )
    else
      flash[:error] = "Failed to add ingredient"
      render 'new'
    end
  end

end