if (Rails.env.eql? "production")
  mail = UserMailer.application_start_email
  mail.deliver
end
