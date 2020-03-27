class FeedbackMailer < ApplicationMailer

  def new_feedback_email
    @feedback = params[:feedback]
    mails = 'aojeda@inciti.com, smonsalves@inciti.com, mbauza@inciti.com'
    mail(to: mails, subject: "Feedback [# #{@feedback.id}]")
  end

end
