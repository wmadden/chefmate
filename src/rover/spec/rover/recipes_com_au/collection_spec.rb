require "rover/recipes_com_au/collection"

describe( 'Rover::RecipesComAu::Collection' ) do
  before( :each ) do
    Mechanize.stub!( :new ).and_return( agent )
  end
  
  let(:agent) { stub(:mechanize_agent) }
  
  let( :collection_url ) { "http://www.somewhere.com" }
  let( :collection ) { Rover::RecipesComAu::Collection.new( '', collection_url ) }
  
  describe( '#fetch' ) do
    subject { collection.fetch }
    
    let( :collection_elements ) { [] }
    let( :recipe_elements ) { [] }
    
    before( :each ) do
      agent.stub_chain( :page, :parser, :css ).and_return( collection_elements, recipe_elements )
      agent.stub( :get )
    end
    
    it( 'should fetch the collection page' ) do
      agent.should_receive( :get ).with( collection_url )
      subject
    end
    
    context( 'when the page contains collections' ) do
      let( :element1 ) { stub(:collection_element1) }
      let( :element2 ) { stub(:collection_element2) }
      let( :collection_elements ) { [ element1, element2 ] }
      
      it( 'should parse each element' ) do
        collection.should_receive(:parse_collection_element).with( element1 ).ordered
        collection.should_receive(:parse_collection_element).with( element2 ).ordered
        subject
      end
      
      it( 'should assign the collections to @collections' ) do
        collection.stub!(:parse_collection_element).and_return( :collection1, :collection2 )
        subject
        collection.collections.should == [ :collection1, :collection2 ]
      end
    end
    
    context( 'when the page contains recipes' ) do
      let( :element1 ) { stub(:recipe_element1) }
      let( :element2 ) { stub(:recipe_element2) }
      let( :recipe_elements ) { [ element1, element2 ] }
      
      it( 'should parse each recipe' ) do
        collection.should_receive(:parse_recipe_element).with(element1).ordered
        collection.should_receive(:parse_recipe_element).with(element2).ordered
        subject
      end
      
      it( 'should assign the recipes to @recipes' ) do
        collection.stub!(:parse_recipe_element).and_return( :recipe1, :recipe2 )
        subject
        collection.recipes.should == [ :recipe1, :recipe2 ]
      end
    end
  end
end