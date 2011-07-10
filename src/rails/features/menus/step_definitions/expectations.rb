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