class Menu < ActiveRecord::Base

  validates_presence_of :name

  has_many :dishes
  has_many :recipes, :through => :dishes

end
