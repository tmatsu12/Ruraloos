class InquiryMailer < ApplicationMailer
  default from: 'noreply@example.com'
  default to: 'admin@example.com'
  layout 'mailer'

  def send_mail(inquiry)
    @inquiry = inquiry
    mail(from: inquiry.email, to: ENV['MAIL_ADDRESS'], subject: 'Webサイトより問い合わせが届きました') do |format|
      format.text
    end
  end
end
