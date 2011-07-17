class Menu < ActiveRecord::Base

  validates_presence_of :name

  has_many :items, :class_name => 'MenuItem'
  has_many :dishes, :through => :items

end
