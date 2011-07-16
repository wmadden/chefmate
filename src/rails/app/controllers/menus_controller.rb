class MenusController < ApplicationController

  before_filter { |c| c.current_tab = :menus }

  def index
    @menus = Menu.find :all
  end

  def new
    @menu = Menu.new
  end

  def create
    @menu = Menu.new( params['menu'] )

    if @menu.save!
      flash[:success] = "Menu created"
      redirect_to menu_path(@menu)
    else
      flash[:error] = "Failed to create menu"
      render 'new'
    end
  end

  def show
    @menu = Menu.find( params['id'] )
  end

  def edit
    @menu = Menu.find( params['id'] )
  end

  def update
    @menu = Menu.find( params['id'] )

    if @menu.update_attributes( params['menu'] )
      flash[:success] = "Menu updated"
      redirect_to menu_path(@menu)
    else
      flash[:error] = "Failed to update menu"
      render 'edit'
    end
  end

end