class FeedbackMailer < ApplicationMailer

  def new_feedback_email
    @feedback = params[:feedback]
    mails = 'pwainer@inciti.com, aojeda@inciti.com, frabanal@inciti.com, mbauza@inciti.com'
    mail(to: mails, subject: "Feedback [# #{@feedback.id}]")
  end

end
