class Ingredient < ActiveRecord::Base

  belongs_to :dish
  belongs_to :component

end
