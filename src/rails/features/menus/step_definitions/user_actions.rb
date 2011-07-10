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
