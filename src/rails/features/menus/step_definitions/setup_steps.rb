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

Given /^the dish "([^"]*)" has the following ingredients:$/ do |dish_name, ingredients|
  @dish = Dish.find_by_name( dish_name )
  ingredients.hashes.each do |ingredient_hash|
    ingredient = @dish.ingredients.new
    ingredient.component = Component.create!( :name => ingredient_hash['name'] )
    ingredient.save!
  end
end

Given /^the menu contains the following dishes:$/ do |dishes|
  dishes.hashes.each do |dish|
    @menu.items << MenuItem.new( :dish => Dish.find_by_name(dish['name']) )
  end
end
