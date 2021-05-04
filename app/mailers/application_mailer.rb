class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SMTP_USERNAME', 'smtp_user_name')
  layout 'mailer'
end
