class Dish < ActiveRecord::Base

  belongs_to :menu
  belongs_to :recipe

  validates_presence_of :recipe, :menu

  delegate :name, :to => :recipe

end
