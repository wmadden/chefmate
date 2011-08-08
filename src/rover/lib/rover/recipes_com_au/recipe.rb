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
        :site => 'recipes.com.au'
      }
      
      @data[:title] = @title
      
      parse_serves
      parse_ingredients
      parse_directions
      parse_times
      parse_nutrition_table
    end
    
    def parse_serves
      serves_string = @agent.page.parser.css(".maincopy .ingredients").css(".serves").text.strip
      
      match = serves_string.match( /\([^0-9]*(\d+)\)/ )
      if !match
        raise "Can't parse servings: #{serves_string}"
      end
      
      @data[:serves] = match[1]
    end
    
    def parse_ingredients
      ul = @agent.page.parser.css(".maincopy .ingredients ul")
      
      @data[:ingredients] = []
      ul.css("li").each do |li|
        ingredient_string = li.text.strip
        
        if match = ingredient_string.match( /([\d,\/]+) ?(#{UNITS.join('|')})? (?:of )?(.*)/ )
          ingredient = {
            :item => match[3]
          }
          
          if match[1] || match[2]
            ingredient[:amount] = {}
            ingredient[:amount][:quantity] = match[1] if match[1]
            ingredient[:amount][:unit] = match[2]     if match[2]
          end
          
          @data[:ingredients] << ingredient
        else
          @data[:ingredients] << ingredient_string
        # end
      end
    end
    
    def parse_directions
      howto_div = @agent.page.parser.css(".maincopy .howto")
      
      @data[:directions] = []
      howto_div.css("#ctl00_PlaceHolderMain_RecipePageControl_content p").each do |p|
        direction_string = p.text.strip
        
        if match = direction_string.match( /\d+\.\s*(.*)/ )
          @data[:directions] << match[1]
        else
          @data[:directions] << direction_string
        end
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
    
    UNITS = [
      'tsp', 'tsps', 'teaspoon', 'teaspoons',
      'tbsp', 'tbsps', 'tablespoon', 'tablespoons',
      'cup', 'cups',
      'g', 'gram', 'grams', 'kg', 'kilo', 'kilos', 'kilogram', 'kilograms',
      'lb', 'pound', 'pounds', 'oz', 'ounce', 'ounces',
      'L', 'litre', 'litres',
      'mL', 'mil', 'mils', 'millilitres',
      'pkt', 'pkts', 'packet', 'packets',
      'slice', 'slices',
      'rasher', 'rashers',
      ]
  end
end