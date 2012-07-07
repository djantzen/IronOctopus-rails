Given /^I am on the sign up page$/ do
  visit new_user_path
end

When /^I fill in "(.*?)" with "(.*?)"$/ do |arg1, arg2|
  fill_in(arg1, :with => arg2)
end

When /^I press "(.*?)"$/ do |arg1|
  click_button 'Sign Up'
end

Then /^the sign up form should be shown again$/ do
  get "users/new"
end

Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^I should not be registered$/ do
  assert_nil User.find_by_email("manisiva19@gmail.com")
end