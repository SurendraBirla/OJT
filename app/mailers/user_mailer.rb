class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Please approved my signup status')
  end

  def approved_user_status
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Your status is approved by Admin')
  end
end
