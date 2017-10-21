Given(/^"([^"]*)" is in the whitelist$/) do |username|
	Whitelist.create!(username: username)
end

Then /^I should be admin$/ do 
	expect(current_user.role).to eq "admin"
end

Given /^I enter the whitelist page$/ do
  visit path_to("the whitelist page")
  sleep(1)
end

When /^I follow the first "Delete"$/ do 
	first(:link, "Delete").click
end