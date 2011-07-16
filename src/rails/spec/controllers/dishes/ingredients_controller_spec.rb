require 'spec_helper'

describe( Dishes::IngredientsController ) do

  let(:ingredient)  { stub_model(Ingredient) }
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
      Component.stub(:find_by_name)
    end

    subject { post 'create', 'dish_id' => 'dish-ID', 'ingredient' => { 'name' => 'Spinach', 'amount' => '250g' } }

    it 'should find the Dish' do
      Dish.should_receive(:find).with('dish-ID')
      subject()
    end

    it 'should find the Component matching the ingredient name' do
      Component.should_receive(:find_by_name).with('Spinach')
      subject()
    end

    describe( 'when no matching component exists' ) do
      before(:each) do
        Component.stub(:find_by_name).and_return( nil )
      end

      it 'should create the component' do
        Component.should_receive(:create!)
        subject()
      end
    end

    describe( 'when the component already exists' ) do
      before(:each) do
        Component.stub(:find_by_name).and_return( component )
      end

      it 'should assign the component to the ingredient' do
        subject()
        ingredient.component.should == component
      end
    end

    it 'should create an Ingredient belonging to the dish' do
      dish.should_receive(:ingredients).and_return(ingredients)
      ingredients.should_receive(:new)

      subject()
    end

    describe 'when the Ingredient is saved successfully' do
      before(:each) do
        ingredient.stub(:save).and_return(true)
      end

      it 'should create a flash message' do
        subject()
        flash[:success].should_not be_nil
      end

      it 'should redirect back to the Dish show' do
        subject()
        response.should redirect_to( dish_path(dish) )
      end
    end

    describe 'when the Ingredient cannot be saved ' do
      before(:each) do
        ingredient.stub(:save).and_return(false)
      end

      it 'should create a flash message' do
        subject()
        flash[:error].should_not be_nil
      end

      it 'should render #new' do
        subject()
        response.should render_template('new')
      end
    end
  end

end