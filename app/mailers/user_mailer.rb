class UserMailer < ActionMailer::Base

  default :from => "david@ironoctop.us"

  def invitation_email(trainer, email_to, license, request)
    @trainer = trainer
    @invitation = Invitation.new(:trainer => @trainer,
                                 :email_to => email_to,
                                 :invitation_uuid => UUID.new.generate,
                                 :license => license)
    @invitation.save

    @url  = "http://#{request.host_with_port}#{accept_path}?invitation_token=#{@invitation.invitation_uuid}"
    mail(:to => email_to, :subject => "#{@trainer.first_name} has invited you to Iron Octopus!")
  end


  def welcome_email(user, request)
    @user = user
    confirmation = Confirmation.new(:user => @user)
    confirmation.save

    @url  = "http://#{request.host_with_port}#{confirm_path}?confirmation_token=#{confirmation.confirmation_uuid}"
    mail(:to => user.email, :subject => "Welcome to Iron Octopus!")
  end
end
