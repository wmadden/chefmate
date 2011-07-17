When /^I click the "([^"]*)" button$/ do |button_text|
  click_button( button_text )
end

When /^I click the "([^"]*)" link$/ do |link_text|
  click_link( link_text )
end

When /^I enter:$/ do |input_table|
  input_table.hashes.each do |hash|
    fill_in( hash['input'], :with => hash['value'] )
  end
end

When /^I choose the ([a-zA-Z_]+) "([^"]+)"$/ do |input_name, value|
  select value, :from => input_name
end

When /^click the "([^"]*)" link$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
