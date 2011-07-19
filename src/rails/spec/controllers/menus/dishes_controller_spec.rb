require "spec_helper"

describe Menus::DishesController do
  let(:dish)      { mock_model(Dish, :save => nil ) }
  let(:dishes)    { mock( :dishes, :new => dish ) }
  let(:menu)      { mock_model( Menu, :dishes => dishes, :id => 'menu-ID' ) }

  before(:each)   { Menu.stub(:find).and_return( menu ) }

  describe '#new' do
    it 'should find the menu' do
      Menu.should_receive(:find).with('menu-ID')
      get 'new', 'menu_id' => 'menu-ID'
    end

    it 'should create a dish belonging to the menu' do
      menu.should_receive(:dishes).and_return(dishes)
      dishes.should_receive(:new)

      get 'new', 'menu_id' => 'menu-ID'
    end

    it 'should assign it to @dish' do
      get 'new', 'menu_id' => 'menu-ID'

      assigns(:dish).should == dish
    end
  end

  describe '#create' do
    let(:recipe) { mock_model(Recipe) }

    before(:each) do
      Recipe.stub(:find).and_return( recipe )
    end

    it 'should find the Menu' do
      Menu.should_receive(:find).with('menu-ID')
      post 'create', 'menu_id' => 'menu-ID', 'dish' => { 'recipe_id' => 'recipe-ID' }
    end

    it 'should create a Dish belonging to the menu' do
      menu.should_receive(:dishes).and_return(dishes)
      dishes.should_receive(:new)

      post 'create', 'menu_id' => 'menu-ID', 'dish' => { 'recipe_id' => 'recipe-ID' }
    end

    describe 'when the Dish is saved successfully' do
      before(:each) do
        dish.stub(:save).and_return(true)
      end

      it 'should create a flash message' do
        post 'create', 'menu_id' => 'menu-ID', 'recipe_id' => 'recipe-ID'
        flash[:success].should_not be_nil
      end

      it 'should redirect back to the Menu show' do
        post 'create', 'menu_id' => 'menu-ID', 'recipe_id' => 'recipe-ID'
        response.should redirect_to( menu_path(menu) )
      end
    end

    describe 'when the Dish cannot be saved ' do
      before(:each) do
        dish.stub(:save).and_return(false)
      end

      it 'should create a flash message' do
        post 'create', 'menu_id' => 'menu-ID', 'recipe_id' => 'recipe-ID'
        flash[:error].should_not be_nil
      end

      it 'should render #new' do
        post 'create', 'menu_id' => 'menu-ID', 'recipe_id' => 'recipe-ID'
        response.should render_template('new')
      end
    end
  end

  describe '#destroy' do
    let(:dish) { mock_model(Dish, :delete => nil, :name => 'abc') }
    let(:dishes) { mock(:dishes, :find => dish) }
    let(:menu) { mock_model(Menu, :dishes => dishes) }

    before(:each) do
      Menu.stub(:find).and_return( menu )
    end

    subject do
      delete 'destroy', 'menu_id' => 'menu-ID', 'id' => 'dish-ID'
    end

    it 'should find the Menu' do
      Menu.should_receive(:find).with('menu-ID')
      subject
    end

    it "should find the Dish in the Menu's dishes collection" do
      dishes.should_receive(:find).with('dish-ID')
      subject
    end

    it "should delete the Dish" do
      dish.should_receive(:delete)
      subject
    end

    it "should output a success message" do
      subject
      flash[:success].should_not be_nil
    end

    it 'should redirect to Menu show' do
      subject
      response.should redirect_to( menu_path(menu) )
    end
  end

end