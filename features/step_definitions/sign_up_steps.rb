And /^I should receive a registration email/ do
  email = UserMailer.deliveries.pop
  email.body.should have_content("Welcome to Iron Octopus, George")
  email.body.to_s =~ /(confirm\?confirmation_token=[\w-]+)/
  get $1
end

Then /^(.*?) should be registered$/ do |email|
  assert_not_nil User.find_by_email(email)
end

Then /^(.*?) should not be registered$/ do |email|
  assert_nil User.find_by_email(email)
end

And /^(.*?) should be confirmed$/ do |email|
  User.find_by_email(email).identity_confirmed.should eq(true)
end

Then /^(.*?) should not be confirmed$/ do |email|
  User.find_by_email(email).identity_confirmed.should eq(false)
end
