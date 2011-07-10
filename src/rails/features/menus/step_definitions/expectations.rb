Then /^I should see the message "([^"]+)"$/ do |message|
  within('#flash-messages') do
    has_content? message
  end
end