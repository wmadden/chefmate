require "spec_helper"

describe Menus::MenuItemsController do
  let(:menu_item) { mock_model(MenuItem, :save => nil ) }
  let(:items)     { mock( :menu_items, :new => menu_item ) }
  let(:menu)      { mock_model( Menu, :items => items, :id => 'menu-ID' ) }

  before(:each)   { Menu.stub(:find).and_return( menu ) }

  describe '#new' do
    it 'should find the menu' do
      Menu.should_receive(:find).with('menu-ID')
      get 'new', 'menu_id' => 'menu-ID'
    end

    it 'should create a menu item belonging to the menu' do
      menu.should_receive(:items).and_return(items)
      items.should_receive(:new)

      get 'new', 'menu_id' => 'menu-ID'
    end

    it 'should assign it to @menu_item' do
      get 'new', 'menu_id' => 'menu-ID'

      assigns(:menu_item).should == menu_item
    end
  end

  describe '#create' do
    let(:dish) { mock_model(Dish) }

    before(:each) do
      Dish.stub(:find).and_return( dish )
    end

    it 'should find the Menu' do
      Menu.should_receive(:find).with('menu-ID')
      post 'create', 'menu_id' => 'menu-ID', 'menu_item' => { 'dish_id' => 'dish-ID' }
    end

    it 'should create a MenuItem belonging to the menu' do
      menu.should_receive(:items).and_return(items)
      items.should_receive(:new)

      post 'create', 'menu_id' => 'menu-ID', 'menu_item' => { 'dish_id' => 'dish-ID' }
    end

    describe 'when the MenuItem is saved successfully' do
      before(:each) do
        menu_item.stub(:save).and_return(true)
      end

      it 'should create a flash message' do
        post 'create', 'menu_id' => 'menu-ID', 'dish_id' => 'dish-ID'
        flash[:success].should_not be_nil
      end

      it 'should redirect back to the Menu show' do
        post 'create', 'menu_id' => 'menu-ID', 'dish_id' => 'dish-ID'
        response.should redirect_to( menu_path(menu) )
      end
    end

    describe 'when the MenuItem cannot be saved ' do
      before(:each) do
        menu_item.stub(:save).and_return(false)
      end

      it 'should create a flash message' do
        post 'create', 'menu_id' => 'menu-ID', 'dish_id' => 'dish-ID'
        flash[:error].should_not be_nil
      end

      it 'should render #new' do
        post 'create', 'menu_id' => 'menu-ID', 'dish_id' => 'dish-ID'
        response.should render_template('new')
      end
    end
  end

end