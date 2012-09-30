And /^I should receive a registration email/ do
  email = UserMailer.deliveries.pop
  email.body.should have_content("Welcome to Iron Octopus, George")
  email.body.to_s =~ /(confirm\?confirmation_token=[\w-]+)/
  get $1
end
