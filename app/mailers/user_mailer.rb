class UserMailer < ActionMailer::Base

  default :from => IronOctopus::Configuration.instance.application[:default_email_from]

  def invitation_email(trainer, email_to, license, request)
    @trainer = trainer
    @invitation = Invitation.new(:trainer => @trainer,
                                 :email_to => email_to,
                                 :license => license)
    @invitation.save

    @url  = "http://#{request.host_with_port}#{accept_path}?invitation_token=#{@invitation.invitation_uuid}"
    mail(:to => email_to, :subject => "#{@trainer.first_name} has invited you to Iron Octopus!")
  end

  def password_reset_request_email(user, request)
    @user = user
    @password_reset_request = PasswordResetRequest.new(:user => @user, :email_to => @user.email)
    @password_reset_request.save
    token = @password_reset_request.password_reset_request_uuid
    @url  = "http://#{request.host_with_port}#{password_reset_requests_path}/#{token}/edit"
    mail(:to => @user.email, :subject => "Password reset link for Iron Octopus")
  end

  def welcome_email(user, request)
    @user = user
    confirmation = Confirmation.new(:user => @user)
    confirmation.save

    @url  = "http://#{request.host_with_port}#{confirm_path}?confirmation_token=#{confirmation.confirmation_uuid}"
    mail(:to => user.email, :subject => "Welcome to Iron Octopus!")
  end

  def application_start_email()
    mail(:to => "mr.djantzen@gmail.com", :subject => "Application is starting")
  end

end
