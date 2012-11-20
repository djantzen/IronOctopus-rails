Then /^I should receive a reset email$/ do
  email = UserMailer.deliveries.pop
  email.body.should have_content("click this link to reset your password")
  email.body.to_s =~ /(password_reset_requests\/[\w-]+\/edit)/
  visit $1
end

Then /^there should exist a PasswordResetRequest for (.*?)$/ do |email|
  user = User.find_by_email(email)
  assert_not_nil PasswordResetRequest.find_by_user_id(user.user_id)
end

Given /^I have clicked on a password reset link for (.*?)$/ do |email|
  reset_request = PasswordResetRequest.find_by_email_to(email).first
  visit "password_reset_requests/#{reset_request.password_reset_request_uuid}/edit"
end

Then /^the PasswordResetRequest for (.*?) should be used$/ do |email|
  reset_request = PasswordResetRequest.find_by_email_to(email)
  assert reset_request.password_reset
end