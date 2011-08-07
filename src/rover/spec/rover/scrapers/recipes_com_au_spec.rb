require "rover"

describe( 'Rover::Scrapers::RecipesComAu' ) do
  
  before( :each ) do
    Mechanize.stub!( :new ).and_return( agent )
  end
  
  let(:scraper) { Rover::Scrapers::RecipesComAu.new }
  let(:agent) { stub(:mechanize_agent) }
  
  describe( '::Collection' ) do
    describe( '#fetch' ) do
      it( 'should load the collections and recipes belonging to the collection' ) do
        pending
      end
    end
  end
  
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
      agent.should_receive( :get ).with( Rover::Scrapers::RecipesComAu::ROOT_URL )
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
      Rover::Scrapers::RecipesComAu::Collection.should_receive( :new )
        .with( link.href )
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
    
    let( :pages ) { [] }
    let( :collections ) { [] }
    let( :collection ) { stub(:collection, :collections => collections, :pages => pages) }
    
    context( 'when the collection has collections' ) do
      let( :collection1 ) { stub(:collection1, :collections => [], :pages => [ :page1 ]) }
      let( :collection2 ) { stub(:collection2, :collections => [], :pages => [ :page2 ]) }
      
      before( :each ) do
        scraper.stub!( :parse_page ).and_return( :parsed_page )
      end
      
      before( :each ) do
        collections << collection1 << collection2
      end
      
      it( 'should return the parsed pages of each collection' ) do
        subject.should == [ :parsed_page, :parsed_page ]
      end
    end
    
    context( 'when the collection has no collections' ) do
      let( :collections ) { [] }
      
      context( 'when the collection has pages' ) do
        let( :page1 ) { stub(:page1) }
        let( :page2 ) { stub(:page2) }
        let( :pages ) { [ page1, page2 ] }
        
        before( :each ) do
          scraper.stub!( :parse_page ).and_return( :parsed_page )
        end
        
        it( 'should parse each page' ) do
          scraper.should_receive(:parse_page).with( page1 ).ordered
          scraper.should_receive(:parse_page).with( page2 ).ordered
          subject
        end
        
        it( 'should return a list of parsed pages' ) do
          subject.should == [ :parsed_page, :parsed_page ]
        end
      end
      
      context( 'when the collection has no pages' ) do
        let( :pages ) { [] }
        it { should == [] }
      end
    end
  end
  
end