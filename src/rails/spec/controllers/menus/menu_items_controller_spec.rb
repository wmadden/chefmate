require "spec_helper"

describe Menus::MenuItemsController do
  
  describe '#new' do
    let(:menu_item) { mock_model(MenuItem) }
    let(:items)     { mock( :menu_items, :new => menu_item ) }
    let(:menu)      { mock_model( Menu, :items => items ) }
    
    before(:each)   { Menu.stub(:find).and_return( menu ) }
    
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
  
end