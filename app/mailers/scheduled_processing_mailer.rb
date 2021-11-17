class ScheduledProcessingMailer < ApplicationMailer
  def check_notice_mail
    @url = "https://ruraloos.com/users/sign_in"
    users_with_unckecked_notices = User.all.select do |user|
      user.passive_notifications.where(visited_id: user.id, checked: false).count >= 10
    end
    users_with_unckecked_notices_mails = users_with_unckecked_notices.pluck(:email)
    mail(subject: "未読の通知が10件以上あります", bcc: users_with_unckecked_notices_mails)
  end
end
