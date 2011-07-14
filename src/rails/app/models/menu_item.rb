class MenuItem < ActiveRecord::Base

  belongs_to :menu
  belongs_to :dish

  validates_presence_of :dish, :menu

end
