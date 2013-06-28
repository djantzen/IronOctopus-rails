And /^Jill should receive an invitation email/ do
  invitation_link = get_invitation_link
  invitation_link =~ /accept\?invitation_token=([\w-]+)/
  invitation_uuid = $1

  post '/users', {
      :invitation_uuid => invitation_uuid,
      :user => { :first_name => 'Jill', :last_name => 'Client', :login => 'jill_the_client',
                 :password => 'password', :password_confirmation => 'password', :email => 'jill_the_client@gmail.com' },
      :city => 'Seattle, Washington'
  }

end

And /^the invitation should be accepted$/ do
  invitation_link = get_invitation_link
  invitation_link =~ /accept\?invitation_token=([\w-]+)/
  invitation = Invitation.find_by_invitation_uuid($1);
  invitation.accepted.should eq true
end

And /^Jim should receive an invitation email/ do
  invitation_link = get_invitation_link
  invitation_link =~ /accept\?invitation_token=([\w-]+)/
  get invitation_link
end

Then /^Client should be on the registration page/ do
  get new_activity_path
end

Then /^(.*?) should be a client of (.*?)$/ do |client_email, trainer_email|
  client = User.find_by_email(client_email)
  trainer = User.find_by_email(trainer_email)
  client.trainers.include?(trainer).should eq(true)
end

private
def get_invitation_link
  email = UserMailer.deliveries.first
  email.body.should have_content("You have been invited to Iron Octopus")
  email.body.to_s =~ /(accept\?invitation_token=[\w-]+)/
  return $1
end