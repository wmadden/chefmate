require "spec_helper"

describe MenusController do
  
  describe '#new' do
    
    it "should assign a new menu to @menu" do
      get 'new'
      assigns(:menu).should be_a_new(Menu)
    end
    
  end
  
  describe '#create' do
    
    let(:menu_valid) { false }
    let(:menu) { mock(:menu, :valid? => menu_valid ) }
    
    before :each do
      Menu.stub(:new).and_return(menu)
    end
    
    it "should call Menu.new with the params from the request" do
      Menu.should_receive(:new).with({ 'name' => 'Some Menu' }).and_return(menu)
      post 'create', { 'menu' => { 'name' => 'Some Menu' } }
    end
    
    it "should check that the menu is valid" do
      Menu.stub(:new).and_return(menu)
      menu.should_receive(:valid?)
      post 'create'
    end
    
    describe 'when the Menu is invalid' do
      let(:menu_valid) { false }
      
      it 'it should render #new' do
        post 'create'
        response.should render_template('new')
      end
    end
    
    describe 'when the Menu is valid' do
      let(:menu_valid) { true }
      
      before :each do
        menu.stub(:save!)
      end
      
      it 'should create the Menu' do
        menu.should_receive 'save!'
        post 'create'
      end
      
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
  
end