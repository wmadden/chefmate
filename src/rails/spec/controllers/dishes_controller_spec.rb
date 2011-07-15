require "spec_helper.rb"

describe( DishesController ) do

  describe '#index' do
    it "should assign all dishes to @dishes" do
      dish1, dish2, dish3 = mock(:dish), mock(:dish), mock(:dish)
      Dish.should_receive(:find).with(:all).and_return( [ dish1, dish2, dish3 ] )

      get 'index'

      assigns(:dishes).should == [ dish1, dish2, dish3 ]
    end
  end

  describe '#new' do
    it "should assign a new Dish to @dish" do
      get 'new'
      assigns(:dish).should be_a_new(Dish)
    end
  end

  describe '#create' do
    let(:dish_valid) { false }
    let(:dish) { mock(:dish, :save => dish_valid ) }

    before :each do
      Dish.stub(:new).and_return(dish)
    end

    it "should call Dish.new with the params from the request" do
      Dish.should_receive(:new).with({ 'name' => 'Some Dish' }).and_return(dish)
      post 'create', { 'dish' => { 'name' => 'Some Dish' } }
    end

    it "should save the dish" do
      dish.should_receive(:save)
      post 'create'
    end

    describe 'when the Dish cannot be saved' do
      let(:dish_valid) { false }

      it 'it should render #new' do
        post 'create'
        response.should render_template('new')
      end

      it 'should create a flash message' do
        post 'create'
        flash[:error].should == "Failed to create dish"
      end
    end

    describe 'when the Dish saves successfully' do
      let(:dish_valid) { true }

      it 'should create a flash message' do
        post 'create'
        flash[:success].should == "Dish created"
      end

      it 'should redirect to #show' do
        post 'create'
        response.should redirect_to( dish_path(dish) )
      end
    end
  end

  describe '#show' do
    it 'should find the Dish' do
      Dish.should_receive(:find).with('dish-ID')
      get 'show', :id => 'dish-ID'
    end

    it 'should assign the Dish to @dish' do
      dish = mock(:dish)
      Dish.stub(:find).and_return( dish )

      get 'show', :id => 'dish-ID'

      assigns(:dish).should == dish
    end
  end

  describe '#edit' do
    it 'should find the Dish' do
      Dish.should_receive(:find).with('dish-ID')
      get 'edit', :id => 'dish-ID'
    end

    it 'should assign the Dish to @dish' do
      dish = mock(:dish)
      Dish.stub(:find).and_return( dish )

      get 'edit', :id => 'dish-ID'

      assigns(:dish).should == dish
    end
  end

  describe '#update' do
    let(:dish_valid) { false }
    let(:dish) { mock(:dish, :update_attributes => dish_valid ) }

    before :each do
      Dish.stub(:find).and_return(dish)
    end

    it 'should find the Dish' do
      Dish.should_receive(:find).with('dish-ID')
      put 'update', :id => 'dish-ID'
    end

    it "should call Dish.update_attributes with the params from the request" do
      dish.should_receive(:update_attributes).with({ 'name' => 'Some Dish' }).and_return(dish)
      put 'update', { 'id' => 'dish-ID', 'dish' => { 'name' => 'Some Dish' } }
    end

    describe 'when the Dish cannot be updated' do
      let(:dish_valid) { false }

      it 'it should render #edit' do
        put 'update', 'id' => 'dish-ID'
        response.should render_template('edit')
      end

      it 'should create a flash message' do
        put 'update', 'id' => 'dish-ID'
        flash[:error].should_not be_nil
      end
    end

    describe 'when the Dish updates successfully' do
      let(:dish_valid) { true }

      before :each do
        dish.stub(:save!)
      end

      it 'should create a flash message' do
        put 'update', 'id' => 'dish-ID'
        flash[:success].should_not be_nil
      end

      it 'should redirect to #show' do
        put 'update', 'id' => 'dish-ID'
        response.should redirect_to( dish_path(dish) )
      end
    end
  end

end