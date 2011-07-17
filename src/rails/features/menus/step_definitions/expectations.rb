Then /^I should see the message "([^"]+)"$/ do |message|
  within('#flash-messages') do
    has_content? message
  end
end

Then /^I should see the names of all existing menus$/ do
  @menus.each do |menu|
    page.should have_content(menu.name)
  end
end

Then /^I should see the heading "([^"]+)"$/ do |heading|
  within("h2") do
    page.should have_content( heading )
  end
end

Then /^I should see the names of all existing recipes$/ do
  @recipes.each do |recipe|
    page.should have_content(recipe.name)
  end
end

Then /^I should see an? ([a-zA-Z]+) message$/ do |message_type|
  page.should have_css("#flash-messages .#{message_type}.message")
end

Then /^I should see the following ingredients:$/ do |ingredients|
  ingredients.hashes.each do |ingredient|
    page.should have_content( ingredient['name'] )
  end
end