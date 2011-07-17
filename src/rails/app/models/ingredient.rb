class Ingredient < ActiveRecord::Base

  belongs_to :recipe
  belongs_to :component

  delegate :name, :to => :component

end
