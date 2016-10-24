Given /^admin with email "(.*)" and password "(.*)" exists/ do |email, password|
	User.create!(email: email, password: password, role: "admin")
end

Given /^coach with email "(.*)" is in the whitelist/ do |email|
	Whitelist.create!(email: email)
end

When /^I sign in as admin with email "(.*)" and password "(.*)"/ do |email, password|
	fill_in "Email", :with => email
	fill_in "Password", :with => password
	click_button "Admin Sign in"
end

When /^I sign in as coach with github email "(.*)"/ do |email|
	OmniAuth.config.add_mock(:github, {
	    :uid => '12345',
	    :extra => {
	      :raw_info => {
	      	:email => email
	      }
	    }
	  })
	click_link "Sign in with GitHub"
end
		