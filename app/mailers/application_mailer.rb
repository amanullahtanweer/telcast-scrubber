class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@scrublists.com'
  layout 'mailer'
end
