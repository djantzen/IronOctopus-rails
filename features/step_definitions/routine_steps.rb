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
    fill_in("routine[activity_set_groups][][activity_sets][][#{measure.downcase}_min]", :with => value)
  end
end

When /^I fill in maximum (.*?) with "(.*?)"$/ do |measure, value|
  within @current_node do
    fill_in("routine[activity_set_groups][][activity_sets][][#{measure.downcase}_max]", :with => value)
  end
end

When /^I make (\w+) a ranged measure$/ do |measure|
  within @current_node.first(".#{measure.downcase}") do
    check "measure-to-range-box"
  end
end

When /^"([^"]*)" should be clear$/ do |form|
  within form do
    all('input[type=checkbox]').each do |checkbox|
      checkbox.should_not be_checked
    end
    all('input[type=text]').each do |input|
      input.value.should == ""
    end
  end
end

When /^"([^"]*)" should not be clear$/ do |form|
  checked = false
  within form do
    all('input[type=checkbox]').each do |checkbox|
      checked = true if checkbox.checked?
    end
  end
  checked
end

Then /^there should be (\d+) activities in the list$/ do |num|
  within page.find("#activity-list") do
    all(".activity", :visible => true).count.should == num.to_i
  end
end

Then /^there should be (\d+) activities$/ do |num|
  activities = all("#activity-list li.activity", :visible => true)
  activities.size == num
end

Then /^minimum ([^"]*) should be "([^"]*)"$/ do |measure, value|
  within @current_node do
    val = first(".#{measure.downcase}").first(".measure-min input").value()
    expect(val).to eq(value)
  end
end

Then /^([^"]*) units should be "([^"]*)"$/ do |measure, value|
  within @current_node do
    val = first(".#{measure.downcase}").first(".unit-selector").value()
    expect(val).to eq(value)
  end
end