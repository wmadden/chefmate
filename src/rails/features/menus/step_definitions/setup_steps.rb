Given /^the following menus exist:$/ do |table|
  @menus = []
  table.hashes.each do |hash|
    @menus << Menu.create!( hash )
  end
end

Given /^the following menu exists:$/ do |table|
  @menu = Menu.create!( table.hashes.first )
end

Given /^the following recipes exist:$/ do |table|
  @recipes = []
  table.hashes.each do |hash|
    @recipes << Recipe.create!( hash )
  end
end

Given /^the following recipe exists:$/ do |table|
  @recipe = Recipe.create!( table.hashes.first )
end

Given /^the recipe "([^"]*)" has the following ingredients:$/ do |recipe_name, ingredients|
  @recipe = Recipe.find_by_name( recipe_name )
  ingredients.hashes.each do |ingredient_hash|
    ingredient = @recipe.ingredients.new
    ingredient.component = Component.create!( :name => ingredient_hash['name'] )
    ingredient.save!
  end
end

Given /^the menu contains the following recipes:$/ do |recipes|
  recipes.hashes.each do |recipe|
    @menu.items << Dish.new( :recipe => Recipe.find_by_name(recipe['name']) )
  end
end
