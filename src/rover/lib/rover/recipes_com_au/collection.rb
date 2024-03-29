require "rover/recipes_com_au"
require "rover/recipes_com_au/recipe"

require "mechanize"
require "uri"

module Rover::RecipesComAu
  class Collection
    
    attr_reader :collections,
                :recipes,
                :title,
                :url
              
    def initialize( title, url )
      @url = url
      @title = title
      @agent = Mechanize.new
      @collections = []
      @recipes = []
    end
  
    def fetch
      puts "Fetching collection #{@title}..."
      @agent.get( @url )
    
      collections = @agent.page.parser.css(".groupbox")
      @collections = collections.map do |element|
        parse_collection_element( element )
      end
    
      recipes = @agent.page.parser.css(".searchpaper .list > tr")
      @recipes = recipes.map do |element|
        parse_recipe_element( element )
      end
    end
  
    # --------
  
    # Note: these methods aren't tested, since they're so heavily dependent on the structure
    # of the page, which isn't controlled by me.
  
    def parse_collection_element( element )
      link = element.css("a")[1]
      Collection.new( link.text, build_uri(link.attr("href")) )
    end
  
    def parse_recipe_element( element )
      Recipe.new( element.css("h4").text.strip,
                  build_uri( element.css("a")[0].attr("href") ) )
    end
  
    def build_uri( uri_string )
      uri = URI.parse( uri_string )
      URI::HTTP.new( @agent.page.uri.scheme,
                     @agent.page.uri.userinfo,
                     @agent.page.uri.host,
                     @agent.page.uri.port,
                     @agent.page.uri.registry,
                     uri.path,
                     @agent.page.uri.opaque,
                     @agent.page.uri.query,
                     @agent.page.uri.fragment )
    end
  
  end
end