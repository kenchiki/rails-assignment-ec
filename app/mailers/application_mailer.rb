class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: EmailSetting.from
  layout 'mailer'
end
