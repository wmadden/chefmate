require "spec_helper"

describe( Dishes::IngredientsController ) do

  let(:ingredient)  { mock_model(Ingredient, :save => nil ) }
  let(:ingredients) { mock( :ingredients, :new => ingredient ) }
  let(:dish)        { mock_model( Dish, :ingredients => ingredients, :id => 'dish-ID' ) }

  before(:each)     { Dish.stub(:find).and_return( dish ) }

  describe '#new' do
    it 'should find the dish' do
      Dish.should_receive(:find).with('dish-ID')
      get 'new', 'dish_id' => 'dish-ID'
    end

    it 'should create a dish item belonging to the dish' do
      dish.should_receive(:ingredients).and_return(ingredients)
      ingredients.should_receive(:new)

      get 'new', 'dish_id' => 'dish-ID'
    end

    it 'should assign it to @ingredient' do
      get 'new', 'dish_id' => 'dish-ID'

      assigns(:ingredient).should == ingredient
    end
  end

  describe '#create' do
    let(:component) { mock_model(Component) }

    before(:each) do
      Component.stub(:find).and_return( component )
    end

    it 'should find the Dish' do
      Dish.should_receive(:find).with('dish-ID')
      post 'create', 'dish_id' => 'dish-ID', 'ingredient' => { 'component_id' => 'component-ID' }
    end

    it 'should create a Ingredient belonging to the dish' do
      dish.should_receive(:ingredients).and_return(ingredients)
      ingredients.should_receive(:new)

      post 'create', 'dish_id' => 'dish-ID', 'ingredient' => { 'component_id' => 'component-ID' }
    end

    describe 'when the Ingredient is saved successfully' do
      before(:each) do
        ingredient.stub(:save).and_return(true)
      end

      it 'should create a flash message' do
        post 'create', 'dish_id' => 'dish-ID', 'component_id' => 'component-ID'
        flash[:success].should_not be_nil
      end

      it 'should redirect back to the Dish show' do
        post 'create', 'dish_id' => 'dish-ID', 'component_id' => 'component-ID'
        response.should redirect_to( dish_path(dish) )
      end
    end

    describe 'when the Ingredient cannot be saved ' do
      before(:each) do
        ingredient.stub(:save).and_return(false)
      end

      it 'should create a flash message' do
        post 'create', 'dish_id' => 'dish-ID', 'component_id' => 'component-ID'
        flash[:error].should_not be_nil
      end

      it 'should render #new' do
        post 'create', 'dish_id' => 'dish-ID', 'component_id' => 'component-ID'
        response.should render_template('new')
      end
    end
  end

end