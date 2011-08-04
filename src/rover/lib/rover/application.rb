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
          scraper = Scrapers::RecipesComAu.new
        else
          puts "Don't know how to scrape #{site}" unless site.nil?
          puts "Usage: wander [site]"
          puts "Known sites:"
          puts "  recipes.com.au"
      end

      scraper.scrape
    end

  end
end