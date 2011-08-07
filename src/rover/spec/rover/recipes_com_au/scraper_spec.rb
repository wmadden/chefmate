require "rover"

describe( 'Rover::RecipesComAu::Scraper' ) do
  
  before( :each ) do
    Mechanize.stub!( :new ).and_return( agent )
  end
  
  let(:scraper) { Rover::RecipesComAu::Scraper.new }
  let(:agent) { stub(:mechanize_agent) }
  
  describe('#scrape') do
    subject { scraper.scrape }
    
    let( :root_collection ) { stub(:root_collection) }
    
    before( :each ) do
      scraper.stub!( :get_root_collection ).and_return( root_collection )
      scraper.stub!( :parse_collection )
    end
    
    it( 'should get the root collection' ) do
      scraper.should_receive(:get_root_collection)
      subject
    end
    
    it( 'should parse the collection' ) do
      scraper.should_receive(:parse_collection).with( root_collection )
      subject
    end
  end
  
  describe( '#fetch_root' ) do
    it( 'should fetch the root of recipes.com.au' ) do
      agent.should_receive( :get ).with( Rover::RecipesComAu::Scraper::ROOT_URL )
      scraper.fetch_root
    end
  end
  
  describe( '#get_root_collection' ) do
    subject { scraper.get_root_collection }
    
    let( :link ) { stub(:link, :href => 'http://www.somewhere.com/') }
    let( :collection_links ) { [ link ] }
    
    before( :each ) do
      scraper.stub!( :fetch_root )
      agent.stub_chain(:page, :links_with).and_return( collection_links )
    end
    
    it( 'should fetch the root page' ) do
      scraper.should_receive( :fetch_root )
      subject
    end
    
    it( 'should create a Collection object targeting the root collections page' ) do
      new_collection = stub(:collection)
      Rover::RecipesComAu::Collection.should_receive( :new )
        .with( '', link.href )
        .and_return( new_collection )
      subject.should == new_collection
    end
  end
  
  describe('#collections') do
    subject { scraper.collections }
    
    let(:collections) { stub(:collections) }
    
    before( :each ) { scraper.stub_chain(:root_collection, :collections) { collections } }
    
    it { should == collections }
  end
  
  describe( '#parse_collection' ) do
    subject { scraper.parse_collection(collection) }
    
    let( :recipes ) { [] }
    let( :collections ) { [] }
    let( :collection ) { stub(:collection,
                              :collections => collections,
                              :recipes => recipes,
                              :fetch => nil ) }
    
    it( 'should fetch the collection' ) do
      collection.should_receive(:fetch)
      subject
    end
    
    context( 'when the collection has collections' ) do
      let( :collection1 ) { stub(:collection1, :collections => [], :recipes => [ :recipe1 ], :fetch => nil) }
      let( :collection2 ) { stub(:collection2, :collections => [], :recipes => [ :recipe2 ], :fetch => nil) }
      
      before( :each ) do
        scraper.stub!( :parse_recipe ).and_return( :parsed_recipe )
      end
      
      before( :each ) do
        collections << collection1 << collection2
      end
      
      it( 'should return the parsed recipes of each collection' ) do
        subject.should == [ :parsed_recipe, :parsed_recipe ]
      end
    end
    
    context( 'when the collection has no collections' ) do
      let( :collections ) { [] }
      
      context( 'when the collection has recipes' ) do
        let( :recipe1 ) { stub(:recipe1) }
        let( :recipe2 ) { stub(:recipe2) }
        let( :recipes ) { [ recipe1, recipe2 ] }
        
        before( :each ) do
          scraper.stub!( :parse_recipe ).and_return( :parsed_recipe )
        end
        
        it( 'should parse each recipe' ) do
          scraper.should_receive(:parse_recipe).with( recipe1 ).ordered
          scraper.should_receive(:parse_recipe).with( recipe2 ).ordered
          subject
        end
        
        it( 'should return a list of parsed recipes' ) do
          subject.should == [ :parsed_recipe, :parsed_recipe ]
        end
      end
      
      context( 'when the collection has no recipes' ) do
        let( :recipes ) { [] }
        it { should == [] }
      end
    end
  end
  
end