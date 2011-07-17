require 'spec_helper'

describe( Recipes::IngredientsController ) do

  let(:ingredient)  { stub_model(Ingredient) }
  let(:ingredients) { mock( :ingredients, :new => ingredient ) }
  let(:recipe)        { mock_model( Recipe, :ingredients => ingredients, :id => 'recipe-ID' ) }

  before(:each)     { Recipe.stub(:find).and_return( recipe ) }

  describe '#new' do
    it 'should find the recipe' do
      Recipe.should_receive(:find).with('recipe-ID')
      get 'new', 'recipe_id' => 'recipe-ID'
    end

    it 'should create a recipe item belonging to the recipe' do
      recipe.should_receive(:ingredients).and_return(ingredients)
      ingredients.should_receive(:new)

      get 'new', 'recipe_id' => 'recipe-ID'
    end

    it 'should assign it to @ingredient' do
      get 'new', 'recipe_id' => 'recipe-ID'

      assigns(:ingredient).should == ingredient
    end
  end

  describe '#create' do
    let(:component) { mock_model(Component) }

    before(:each) do
      Component.stub(:find_by_name)
    end

    subject { post 'create', 'recipe_id' => 'recipe-ID', 'ingredient' => { 'name' => 'Spinach', 'amount' => '250g' } }

    it 'should find the Recipe' do
      Recipe.should_receive(:find).with('recipe-ID')
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

    it 'should create an Ingredient belonging to the recipe' do
      recipe.should_receive(:ingredients).and_return(ingredients)
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

      it 'should redirect back to the Recipe show' do
        subject()
        response.should redirect_to( recipe_path(recipe) )
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