And /^Jill should receive an invitation email/ do
  email = UserMailer.deliveries.pop
  email.body.should have_content("You have been invited to Iron Octopus")
  email.body.to_s =~ /accept\?invitation_token=([\w-]+)/
  invitation_uuid = $1

  post '/users', {
      :invitation_uuid => invitation_uuid,
      :user => { :first_name => 'Jill', :last_name => 'Client', :login => 'jill_the_client',
                 :password => 'password', :password_confirmation => 'password', :email => 'jill_the_client@gmail.com' }
  }

end

And /^Jim should receive an invitation email/ do
  email = UserMailer.deliveries.pop
  email.body.should have_content("You have been invited to Iron Octopus")
  email.body.to_s =~ /(accept\?invitation_token=[\w-]+)/
  get $1
end

Then /^Client should be on the registration page/ do
  get new_activity_path
end


