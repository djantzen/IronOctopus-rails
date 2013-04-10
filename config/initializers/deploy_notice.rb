if (Rails.env.eql? "production")
  mail = UserMailer.create_application_start_email
  mail.deliver
end
