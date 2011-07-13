class Menus::MenuItemsController < ApplicationController
  
  def new
    menu = Menu.find( params['menu_id'] )
    @menu_item = menu.items.new
  end
  
end
