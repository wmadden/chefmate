class Ingredient < ActiveRecord::Base

  belongs_to :dish
  belongs_to :component

  delegate :name, :to => :component

end
