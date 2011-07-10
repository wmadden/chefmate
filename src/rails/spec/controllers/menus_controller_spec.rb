require "spec_helper"

describe MenusController do
  
  describe '#index' do
    it "should assign all menus to @menus" do
      menu1, menu2, menu3 = mock(:menu), mock(:menu), mock(:menu)
      Menu.should_receive(:find).with(:all).and_return( [ menu1, menu2, menu3 ] )
      
      get 'index'
      
      assigns(:menus).should == [ menu1, menu2, menu3 ]
    end
  end
  
  describe '#new' do
    it "should assign a new menu to @menu" do
      get 'new'
      assigns(:menu).should be_a_new(Menu)
    end
  end
  
  describe '#create' do
    let(:menu_valid) { false }
    let(:menu) { mock(:menu, :save! => menu_valid ) }
    
    before :each do
      Menu.stub(:new).and_return(menu)
    end
    
    it "should call Menu.new with the params from the request" do
      Menu.should_receive(:new).with({ 'name' => 'Some Menu' }).and_return(menu)
      post 'create', { 'menu' => { 'name' => 'Some Menu' } }
    end
    
    it "should save! the menu" do
      menu.should_receive(:save!)
      post 'create'
    end
    
    describe 'when the Menu cannot be saved' do
      let(:menu_valid) { false }
      
      it 'it should render #new' do
        post 'create'
        response.should render_template('new')
      end
      
      it 'should create a flash message' do
        post 'create'
        flash[:error].should == "Failed to create menu"
      end
    end
    
    describe 'when the Menu saves successfully' do
      let(:menu_valid) { true }
      
      it 'should create a flash message' do
        post 'create'
        flash[:success].should == "Menu created"
      end
      
      it 'should redirect to #show' do
        post 'create'
        response.should redirect_to( menu_path(menu) )
      end
    end
  end
  
  describe '#show' do
    it 'should find the Menu' do
      Menu.should_receive(:find).with('menu-ID')
      get 'show', :id => 'menu-ID'
    end
    
    it 'should assign the Menu to @menu' do
      menu = mock(:menu)
      Menu.stub(:find).and_return( menu )
      
      get 'show', :id => 'menu-ID'
      
      assigns(:menu).should == menu
    end
  end
  
  describe '#edit' do
    it 'should find the Menu' do
      Menu.should_receive(:find).with('menu-ID')
      get 'edit', :id => 'menu-ID'
    end
    
    it 'should assign the Menu to @menu' do
      menu = mock(:menu)
      Menu.stub(:find).and_return( menu )
      
      get 'edit', :id => 'menu-ID'
      
      assigns(:menu).should == menu
    end
  end
  
  describe '#update' do
    let(:menu_valid) { false }
    let(:menu) { mock(:menu, :update_attributes => menu_valid ) }
    
    before :each do
      Menu.stub(:find).and_return(menu)
    end
    
    it 'should find the Menu' do
      Menu.should_receive(:find).with('menu-ID')
      put 'update', :id => 'menu-ID'
    end
    
    it "should call Menu.update_attributes with the params from the request" do
      menu.should_receive(:update_attributes).with({ 'name' => 'Some Menu' }).and_return(menu)
      put 'update', { 'id' => 'menu-ID', 'menu' => { 'name' => 'Some Menu' } }
    end
    
    describe 'when the Menu cannot be updated' do
      let(:menu_valid) { false }
      
      it 'it should render #edit' do
        put 'update', 'id' => 'menu-ID'
        response.should render_template('edit')
      end
      
      it 'should create a flash message' do
        put 'update', 'id' => 'menu-ID'
        flash[:error].should == "Failed to update menu"
      end
    end
    
    describe 'when the Menu updates successfully' do
      let(:menu_valid) { true }
      
      before :each do
        menu.stub(:save!)
      end
      
      it 'should create a flash message' do
        put 'update', 'id' => 'menu-ID'
        flash[:success].should == "Menu updated"
      end
      
      it 'should redirect to #show' do
        put 'update', 'id' => 'menu-ID'
        response.should redirect_to( menu_path(menu) )
      end
    end
  end
  
end