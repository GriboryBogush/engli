# Used to mail stuff

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  # Mailer method to send an email on every 5 votes
  # Doesn't actually send mail yet, that needs to be enabled in the config
  def notify_five_upvotes
    @user = params[:user]
    @phrase = params[:phrase]
    mail(to: @user.email, subject: 'You\'ve got another five upvotes!')
  end
end
