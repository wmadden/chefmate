class MenusController < ApplicationController
  
  def index
  end
  
  def new
    @menu = Menu.new
  end
  
  def create
    @menu = Menu.new( params['menu'] )
    if @menu.valid?
      @menu.save!
      flash[:success] = "Menu created"
      redirect_to menu_path(@menu)
    else
      render 'new'
    end
  end
  
  def show
    @menu = Menu.find( params['id'] )
  end
  
end