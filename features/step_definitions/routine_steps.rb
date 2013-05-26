When /^there should be (\d+) activity sets$/ do |size|
  activity_set_list = page.first("#routine-activity-set-list")
  activity_set_list.all(".activity-set-form").size.should be size.to_i
end

Given /^I find the (\d+)\w+ activity set$/ do |position|
  query = "#routine-activity-set-list .activity-set-form:nth(#{position})"
  @current_node = page.first(query)
  @current_node
end

When /^I fill in minimum (.*?) with "(.*?)"$/ do |measure, value|
  within @current_node do
    fill_in("routine[activity_sets][][#{measure.downcase}_min]", :with => value)
  end
end

When /^I fill in maximum (.*?) with "(.*?)"$/ do |measure, value|
  within @current_node do
    fill_in("routine[activity_sets][][#{measure.downcase}_max]", :with => value)
  end
end

When /^I make (\w+) a ranged measure$/ do |measure|
  within @current_node.first(".#{measure.downcase}") do
    check "measure-to-range-box"
  end
end