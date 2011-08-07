require "pp"
require "mechanize"
require "uri"

require "rover/recipes_com_au"
require "rover/recipes_com_au/collection"

module Rover::RecipesComAu
  
  class Scraper
    attr_reader :root_collection,
                :agent
    
    PARSER_VERSION = [1,0,0]
    ROOT_URL = 'http://recipes.com.au/'
    
    def collections
      root_collection.collections
    end
    
    def initialize
      @agent = Mechanize.new
    end
    
    def scrape
      @root_collection = get_root_collection
      
      parse_collection( @root_collection )
    end
    
    def fetch_root
      puts "Fetching recipes.com.au..."
      @agent.get( ROOT_URL )
    end
    
    def get_root_collection
      fetch_root
      Collection.new( '', @agent.page.links_with(:text => 'recipe collections')[0].href )
    end
    
    def parse_collection( collection )
      collection.fetch
      
      if collection.collections.length > 0
        recipes = []
        collection.collections.each do |subcollection|
          recipes += parse_collection( subcollection )
        end
        recipes
      elsif collection.recipes.length > 0
        collection.recipes.map do |recipe|
          parse_recipe( recipe )
        end
      else
        []
      end
    end
    
    def parse_recipe( recipe )
      return recipe
    end
    
    # -------------------
    
    def find_collections
      @agent.page.parser.css(".groupbox")
    end

    def prompt_for_collection(collections)
      puts "Found the following collections:"
      for i in 0 .. collections.length-1
        collection = collections[i]
        puts "  #{i}) #{collection.css("a")[1].text}"
      end

      puts "Which one do you want to explore? "
      index = 0#$stdin.gets.to_i
      collections[index]
    end

    def prompt_for_recipe
      recipes = find_recipes

      puts "Found the following recipes:"
      for i in 0..recipes.length-1
        recipe = recipes[i]
        puts "  #{i}) #{recipe.css("h4").text.strip}"
      end

      puts "Which one do you want to steal?"
      index = $stdin.gets.to_i
      recipes[index]
    end
    
    def save_recipe( recipe )
      @db ||= Mongo::Connection.new.db("chefmate")
      @collection ||= @db.collection("recipes")
      @collection.insert(recipe)
    end
  end

end