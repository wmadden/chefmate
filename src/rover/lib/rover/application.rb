require 'rubygems'
require 'mechanize'
require 'mongo'

module Rover
  class Application

    def self.run( argv )
      app = Application.new
      app.run( *argv )
    end

    def run( site )
      case site
        when "recipes.com.au"
          scraper = RecipesComAu::Scraper.new
        else
          puts "Don't know how to scrape #{site}" unless site.nil?
          puts "Usage: wander [site]"
          puts "Known sites:"
          puts "  recipes.com.au"
      end
      
      recipes = scraper.scrape
      recipes.each do |recipe|
        puts "Fetching recipe '#{recipe.url}'..."
        recipe.fetch
        save_recipe( recipe )
      end
    end
    
    def save_recipe( recipe )
      @db ||= Mongo::Connection.new.db("chefmate")
      @collection ||= @db.collection("recipes")
      @collection.insert( recipe.data )
    end
  end
end