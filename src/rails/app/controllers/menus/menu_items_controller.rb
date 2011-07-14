class Menus::MenuItemsController < ApplicationController

  def new
    menu = Menu.find( params['menu_id'] )
    @menu_item = menu.items.new
  end

  def create
    menu = Menu.find( params['menu_id'] )
    @menu_item = menu.items.new( params['menu_item'] )

    if @menu_item.save
      flash[:success] = "Menu item created successfully"
      redirect_to( menu_path(menu) )
    else
      flash[:error] = "Failed to create menu item"
      render 'new'
    end
  end

end
