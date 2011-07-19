class Menus::DishesController < ApplicationController

  def new
    @menu = Menu.find( params['menu_id'] )
    @dish = @menu.dishes.new
  end

  def create
    @menu = Menu.find( params['menu_id'] )
    @dish = @menu.dishes.new( params['dish'] )

    if @dish.save
      flash[:success] = "Dish added successfully"
      redirect_to( menu_path(@menu) )
    else
      flash[:error] = "Failed to add dish"
      render 'new'
    end
  end

  def destroy
    @menu = Menu.find( params['menu_id'] )
    @dish = @menu.dishes.find( params['id'] )

    @dish.delete

    flash[:success] = "Successfully removed #{@dish.name} from the menu"

    redirect_to menu_path(@menu)
  end

end
