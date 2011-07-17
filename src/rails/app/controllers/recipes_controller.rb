class RecipesController < ApplicationController

  before_filter { |c| c.current_tab = :recipes }

  def index
    @recipes = Recipe.find :all
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new( params['recipe'] )

    if @recipe.save
      flash[:success] = "Recipe created"
      redirect_to recipe_path(@recipe)
    else
      flash[:error] = "Failed to create recipe"
      render 'new'
    end
  end

  def show
    @recipe = Recipe.find( params['id'] )
  end

  def edit
    @recipe = Recipe.find( params['id'] )
  end

  def update
    @recipe = Recipe.find( params['id'] )

    if @recipe.update_attributes( params['recipe'] )
      flash[:success] = "Recipe updated"
      redirect_to recipe_path(@recipe)
    else
      flash[:error] = "Failed to update recipe"
      render 'edit'
    end
  end

end