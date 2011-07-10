Given /^I am on xthe existing menus screen$/ do
  visit '/menus'
end

Given /^the following menus exist:$/ do |table|
  @menus = []
  table.hashes.each do |hash|
    @menus << Menu.create!( hash )
  end
end

Given /^the following menu exists:$/ do |table|
  @menu = Menu.create!( table.hashes.first )
end