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
    
    def parse_ingredients
      ul = @agent.page.parser.css(".maincopy .ingredients ul")
      
      result = []
      ul.css("li").each do |li|
        result << li.text.strip
      end
      
      result
    end
    
    def parse_directions
      howto_div = @agent.page.parser.css(".maincopy .howto")
      result = []
      howto_div.css("#ctl00_PlaceHolderMain_RecipePageControl_content p").each do |p|
        result << p.text.strip
      end
      result
    end
    
    def parse_preparation_time
      recipe_div = @agent.page.parser.css(".maincopy")
      recipe_div.css(".howto > p")[0].css("span").text.strip
    end
    
    def parse_cooking_time
      recipe_div = @agent.page.parser.css(".maincopy")
      recipe_div.css(".howto > p")[1].css("span").text.strip
    end
    
    def parse_nutrition_table
      nutpaper_div = @agent.page.parser.css(".nutpaper")
      result = {}
    
      rows = nutpaper_div.css("tr")
      rows.slice(1..-1).each do |row|
        cells = row.css("td")
        result[ cells[0].text.strip ] = cells[1].text.strip
      end
    
      result
    end
    
  end
end