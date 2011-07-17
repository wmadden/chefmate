require "spec_helper.rb"

describe( RecipesController ) do

  describe '#index' do
    it "should assign all recipes to @recipes" do
      recipe1, recipe2, recipe3 = mock(:recipe), mock(:recipe), mock(:recipe)
      Recipe.should_receive(:find).with(:all).and_return( [ recipe1, recipe2, recipe3 ] )

      get 'index'

      assigns(:recipes).should == [ recipe1, recipe2, recipe3 ]
    end
  end

  describe '#new' do
    it "should assign a new Recipe to @recipe" do
      get 'new'
      assigns(:recipe).should be_a_new(Recipe)
    end
  end

  describe '#create' do
    let(:recipe_valid) { false }
    let(:recipe) { mock(:recipe, :save => recipe_valid ) }

    before :each do
      Recipe.stub(:new).and_return(recipe)
    end

    it "should call Recipe.new with the params from the request" do
      Recipe.should_receive(:new).with({ 'name' => 'Some Recipe' }).and_return(recipe)
      post 'create', { 'recipe' => { 'name' => 'Some Recipe' } }
    end

    it "should save the recipe" do
      recipe.should_receive(:save)
      post 'create'
    end

    describe 'when the Recipe cannot be saved' do
      let(:recipe_valid) { false }

      it 'it should render #new' do
        post 'create'
        response.should render_template('new')
      end

      it 'should create a flash message' do
        post 'create'
        flash[:error].should == "Failed to create recipe"
      end
    end

    describe 'when the Recipe saves successfully' do
      let(:recipe_valid) { true }

      it 'should create a flash message' do
        post 'create'
        flash[:success].should == "Recipe created"
      end

      it 'should redirect to #show' do
        post 'create'
        response.should redirect_to( recipe_path(recipe) )
      end
    end
  end

  describe '#show' do
    it 'should find the Recipe' do
      Recipe.should_receive(:find).with('recipe-ID')
      get 'show', :id => 'recipe-ID'
    end

    it 'should assign the Recipe to @recipe' do
      recipe = mock(:recipe)
      Recipe.stub(:find).and_return( recipe )

      get 'show', :id => 'recipe-ID'

      assigns(:recipe).should == recipe
    end
  end

  describe '#edit' do
    it 'should find the Recipe' do
      Recipe.should_receive(:find).with('recipe-ID')
      get 'edit', :id => 'recipe-ID'
    end

    it 'should assign the Recipe to @recipe' do
      recipe = mock(:recipe)
      Recipe.stub(:find).and_return( recipe )

      get 'edit', :id => 'recipe-ID'

      assigns(:recipe).should == recipe
    end
  end

  describe '#update' do
    let(:recipe_valid) { false }
    let(:recipe) { mock(:recipe, :update_attributes => recipe_valid ) }

    before :each do
      Recipe.stub(:find).and_return(recipe)
    end

    it 'should find the Recipe' do
      Recipe.should_receive(:find).with('recipe-ID')
      put 'update', :id => 'recipe-ID'
    end

    it "should call Recipe.update_attributes with the params from the request" do
      recipe.should_receive(:update_attributes).with({ 'name' => 'Some Recipe' }).and_return(recipe)
      put 'update', { 'id' => 'recipe-ID', 'recipe' => { 'name' => 'Some Recipe' } }
    end

    describe 'when the Recipe cannot be updated' do
      let(:recipe_valid) { false }

      it 'it should render #edit' do
        put 'update', 'id' => 'recipe-ID'
        response.should render_template('edit')
      end

      it 'should create a flash message' do
        put 'update', 'id' => 'recipe-ID'
        flash[:error].should_not be_nil
      end
    end

    describe 'when the Recipe updates successfully' do
      let(:recipe_valid) { true }

      before :each do
        recipe.stub(:save!)
      end

      it 'should create a flash message' do
        put 'update', 'id' => 'recipe-ID'
        flash[:success].should_not be_nil
      end

      it 'should redirect to #show' do
        put 'update', 'id' => 'recipe-ID'
        response.should redirect_to( recipe_path(recipe) )
      end
    end
  end

end