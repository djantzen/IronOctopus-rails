When /^there should be (\d+) activity sets$/ do |size|
  activity_set_list = page.first("#routine-activity-set-list")
  activity_set_list.all(".activity-set-form").size.should be size.to_i
end