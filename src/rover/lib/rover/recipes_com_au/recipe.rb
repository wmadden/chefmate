require "rover/recipes_com_au"
require "mechanize"

module Rover::RecipesComAu
  
  class Recipe
    
    attr_reader :title,
                :url,
                :data
    
    def initialize( title, url )
      @title = title
      @url = url
      @agent = Mechanize.new
      @data = {}
    end
    
    def fetch
      @agent.get( @url )
      parse
    end
    
    def parse
      @data = Hash.new { |h,k| h[k] = {} }
      
      @data[:parser][:version] = Rover::RecipesComAu::PARSER_VERSION
      
      @data[:source] = {
        :url => @url,
        :site => :'recipes.com.au'
      }
      
      @data[:title] = @title
      
      parse_ingredients
      parse_directions
      parse_times
      parse_nutrition_table
      parse_serving_info
    end
    
  end
  
end