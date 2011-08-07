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
      
      @data[:parser] = {
        :parsed_at => Time.now,
        :version => Rover::RecipesComAu::PARSER_VERSION
      }
      
      @data[:source] = {
        :url => @url.to_s,
        :site => :'recipes.com.au'
      }
      
      @data[:title] = @title
      @data[:serves] = @agent.page.parser.css(".maincopy .ingredients").css(".serves").text.strip
      
      parse_ingredients
      parse_directions
      parse_times
      parse_nutrition_table
    end
    
    def parse_ingredients
      ul = @agent.page.parser.css(".maincopy .ingredients ul")
      
      @data[:ingredients] = []
      ul.css("li").each do |li|
        @data[:ingredients] << li.text.strip
      end
    end
    
    def parse_directions
      howto_div = @agent.page.parser.css(".maincopy .howto")
      
      @data[:directions] = []
      howto_div.css("#ctl00_PlaceHolderMain_RecipePageControl_content p").each do |p|
        @data[:directions] << p.text.strip
      end
    end
    
    def parse_times
      recipe_div = @agent.page.parser.css(".maincopy")
      @data[:preparation_time] = recipe_div.css(".howto > p")[0].css("span").text.strip
      
      recipe_div = @agent.page.parser.css(".maincopy")
      @data[:cooking_time] = recipe_div.css(".howto > p")[1].css("span").text.strip
    end
    
    def parse_nutrition_table
      nutpaper_div = @agent.page.parser.css(".nutpaper")
      @data[:nutrition_table] = {}
    
      rows = nutpaper_div.css("tr")
      rows.slice(1..-1).each do |row|
        cells = row.css("td")
        @data[:nutrition_table][ cells[0].text.strip ] = cells[1].text.strip
      end
    end
    
  end
end