class UserMailer < ActionMailer::Base
  default from: "ddarkeau@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password.subject
  #

  def reset_password(temp_password)
    tmp = temp_password
    host = Rails.configuration.hostname
    @path = 'http://' + host + password_change_path(tmp.uuid)
    mail(to: tmp.email,
         subject: 'Password Reset')
  end
end
