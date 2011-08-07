require "pp"
require "mechanize"

module Rover
module Scrapers
  
  class RecipesComAu
    attr_reader :root_collection,
                :agent
    
    ROOT_URL = 'http://recipes.com.au/'
    
    class Collection
      attr_reader :collections,
                  :recipes
                  
      def initialize( url )
        @url = url
        @agent = Mechanize.new
        @collections = []
        @recipes = []
      end
      
      def fetch
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
        Collection.new( link.text, link.attr("href") )
      end
      
      def parse_recipe_element( element )
        {
          :title => element.css("h4").text.strip,
          :url => element.css("a")[0].attr("href")
        }
      end
    end
    
    def collections
      root_collection.collections
    end
    
    def initialize
      @agent = Mechanize.new
    end
    
    def scrape
      @root_collection = get_root_collection
      
      parse_collection( @root_collection )
      # go_to_collections_page
      #       
      #       collections = find_collections
      #       
      #       while collections.length > 0
      #         collection = prompt_for_collection(collections)
      #         @collection_page = go_to_collection_page(collection)
      #         collections = find_collections
      #       end
      #       
      #       while true
      #         recipe = prompt_for_recipe
      #         
      #         go_to_recipe(recipe)
      #         
      #         recipe = parse_recipe
      #         pp recipe
      #         
      #         save_recipe( recipe )
      #       end
    end
    
    def fetch_root
      puts "Fetching recipes.com.au..."
      @agent.get( ROOT_URL )
    end
    
    def get_root_collection
      fetch_root
      Collection.new( @agent.page.links_with(:text => 'recipe collections')[0].href )
    end
    
    def parse_collection( collection )
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
    
    def go_to_recipe( recipe )
      @agent.get( recipe.css("a")[0].attr("href") )
    end

    def parse_recipe
      recipe = {}
      
      recipe[:source] = {
        :uri => @agent.page.uri.to_s,
        :site => "recipes.com.au"
      }
      
      recipe[:parser] = {
        :version => "1.0.0",
        :parsed_at => Time.now
      }
      
      recipe_div = @agent.page.parser.css(".maincopy")

      recipe[:title] = recipe_div.css("h2").text.strip

      ingredients_div = recipe_div.css(".ingredients")
      recipe[:serves] = ingredients_div.css(".serves").text.strip

      recipe[:ingredients] = parse_ingredients( ingredients_div.css("ul") )
      recipe[:directions] = parse_directions( recipe_div.css(".howto") )
      recipe[:preparation_time] = parse_preparation_time( recipe_div )
      recipe[:cooking_time] = parse_cooking_time( recipe_div )
      recipe[:nutrition_table] = parse_nutrition_table( @agent.page.parser.css(".nutpaper") )

      recipe
    end

    def parse_ingredients( ul )
      result = []
      ul.css("li").each do |li|
        result << li.text.strip
      end
      result
    end

    def parse_directions( howto_div )
      result = []
      howto_div.css("#ctl00_PlaceHolderMain_RecipePageControl_content p").each do |p|
        result << p.text.strip
      end
      result
    end

    def parse_preparation_time( recipe_div )
      recipe_div.css(".howto > p")[0].css("span").text.strip
    end

    def parse_cooking_time( recipe_div )
      recipe_div.css(".howto > p")[1].css("span").text.strip
    end

    def parse_nutrition_table( nutpaper_div)
      result = {}

      rows = nutpaper_div.css("tr")
      rows.slice(1..-1).each do |row|
        cells = row.css("td")
        result[ cells[0].text.strip ] = cells[1].text.strip
      end

      result
    end

    def go_to_collection_page(collection)
      @agent.get(collection.css("a")[1].attr("href"))
      @agent.page.parser
    end

    def find_recipes
      @collection_page.css(".searchpaper .list > tr")
    end
    
    def save_recipe( recipe )
      @db ||= Mongo::Connection.new.db("chefmate")
      @collection ||= @db.collection("recipes")
      @collection.insert(recipe)
    end
  end
  
end
end