When /^I fill in "(.*?)" with "(.*?)"$/ do |arg1, arg2|
  fill_in(arg1, :with => arg2)
end

When /^I press "(.*?)"$/ do |locator|
  click_button locator
end

When /^I click "(.*?)"$/ do |link|
  click_link link
end

Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_content(arg1)
end

And /^I am on the (.*?) page$/ do |arg1|
  visit arg1
end

Given %{I log in as "$login" with "$password"} do |login, password|
  step %{I am on the login page}
  step %{I fill in "Login" with "#{login}"}
  step %{I fill in "Password" with "#{password}"}
  step %{I press "Log in"}
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

Then /^(.*?) should be a client of (.*?)$/ do |client_email, trainer_email|
  client = User.find_by_email(client_email)
  trainer = User.find_by_email(trainer_email)
  client.trainers.include?(trainer).should eq(true)
end
When /^I select "([^"]*)" from "([^"]*)"$/ do |arg1, arg2|
  select(arg1, :from => arg2)
end