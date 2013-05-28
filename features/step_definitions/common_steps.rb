When /^I fill in "(.*?)" with "(.*?)"$/ do |arg1, arg2|
  fill_in(arg1, :with => arg2)
end

When /^I press "(.*?)"$/ do |locator|
  click_button locator
end

When /^I click "(.*?)"$/ do |link|
  begin
    thingy = page.first(link)
    thingy.click if (thingy)
  rescue
    click_link link
  end
end

Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^within "(.*?)" I should see "(.*?)"$/ do |section, content|
  page.first(section).should have_content(content)
end

And /^I am on the (.*?) page$/ do |arg1|
  visit arg1
end

Given %{I log in as "$login" with "$password"} do |login, password|
  step %{I am on the /login page}
  step %{I fill in "Login" with "#{login}"}
  step %{I fill in "Password" with "#{password}"}
  step %{I press "Log in"}
end

When /^I select "([^"]*)" from "([^"]*)"$/ do |arg1, arg2|
  select(arg1, :from => arg2)
end

Then /^"([^"]*)" should not be visible$/ do |node|
  !find(node).visible?
end

Then /^"([^"]*)" should be visible$/ do |node|
  find(node).visible?
end
