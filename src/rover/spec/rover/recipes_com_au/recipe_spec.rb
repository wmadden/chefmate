require "rover/recipes_com_au/recipe"

describe(Rover::RecipesComAu::Recipe) do
  
  before( :each ) do
    Mechanize.stub!( :new ).and_return( agent )
  end
  
  let( :agent ) { stub(:mechanize_agent) }
  
  let( :recipe_title ) { 'Some Recipe' }
  let( :recipe_url ) { "http://www.somewhere.com" }
  let( :recipe ) { Rover::RecipesComAu::Recipe.new( recipe_title, recipe_url ) }
  
  describe( '#fetch' ) do
    
    subject { recipe.fetch }
    
    before( :each ) do
      recipe.stub!( :parse )
      agent.stub!( :get )
    end
    
    it( 'should fetch the recipe page' ) do
      agent.should_receive(:get).with( recipe_url )
      subject
    end
    
    it( 'should parse the recipe' ) do
      recipe.should_receive(:parse)
      subject
    end
    
  end
  
  describe( '#parse' ) do
    
    subject { recipe.parse }
    
    before( :each ) do
      recipe.stub!( :parse_ingredients )
      recipe.stub!( :parse_directions )
      recipe.stub!( :parse_times )
      recipe.stub!( :parse_nutrition_table )
    end
    
    it( 'should set the parser info' ) do
      Time.stub!( :now ).and_return(:now)
      subject
      recipe.data[:parser][:version].should == Rover::RecipesComAu::PARSER_VERSION
      recipe.data[:parser][:parsed_at].should == :now
    end
    
    it( 'should set the source' ) do
      subject
      recipe.data[:source][:url].should == recipe_url
      recipe.data[:source][:site].should == :'recipes.com.au'
    end
    
    it( 'should set the title' ) do
      subject
      recipe.data[:title] == recipe_title
    end
    
    it( 'should parse the ingredients list' ) do
      recipe.should_receive( :parse_ingredients )
      subject
    end
    
    it( 'should parse the directions' ) do
      recipe.should_receive( :parse_directions )
      subject
    end
    
    it( 'should parse the preparation and cooking times' ) do
      recipe.should_receive( :parse_times )
      subject
    end
    
    it( 'should parse the nutrition table' ) do
      recipe.should_receive( :parse_nutrition_table )
      subject
    end
    
  end
  
end