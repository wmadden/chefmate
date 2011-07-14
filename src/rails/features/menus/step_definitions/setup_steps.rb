Given /^the following menus exist:$/ do |table|
  @menus = []
  table.hashes.each do |hash|
    @menus << Menu.create!( hash )
  end
end

Given /^the following menu exists:$/ do |table|
  @menu = Menu.create!( table.hashes.first )
end

Given /^the following dishes exist:$/ do |table|
  @dishes = []
  table.hashes.each do |hash|
    @dishes << Dish.create!( hash )
  end
end

Given /^the following dish exists:$/ do |table|
  @dish = Dish.create!( table.hashes.first )
end