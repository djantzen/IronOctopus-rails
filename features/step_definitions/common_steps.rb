When /^I fill in "(.*?)" with "(.*?)"$/ do |arg1, arg2|
  fill_in(arg1, :with => arg2)
end

When /^I press "(.*?)"$/ do |locator|
  click_button locator
end

When /^I click "(.*?)"$/ do |link|
  begin
#    link = '#' + link unless link =~ /^#/
    thingy = page.first(link)
    if thingy
      thingy.click
    else
      click_link link
    end
  rescue # catch errors when locating nodes using bad syntax (e.g. '?' marks)
    click_link link
  end
end

Then /^I should see "(.*?)"$/ do |content|
  page.should have_content(content)
end

Then /^I should not see "([^"]*)"$/ do |content|
  page.should_not have_content(content)
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

When /^I select "([^"]*)" from "([^"]*)"$/ do |selector, menu|
  if @current_node
    within @current_node do
      select(selector, :from => menu)
    end
  else
    select(selector, :from => menu)
  end
end

Then /^"([^"]*)" should not be visible$/ do |node|
  !find(node).visible?
end

Then /^"([^"]*)" should be visible$/ do |node|
  find(node).visible?
end

When /^I am on (.*?)'s homepage$/ do |username|
  visit "/users/#{username}"
end

When /^I log out$/ do
  visit "/log_out"
end