class ScheduledProcessingMailer < ApplicationMailer
  def check_notice_mail
    @url = "https://ruraloos.com/users/sign_in"
    temp_users = []
    User.all.each do |user|
      temp_users << user if (user.passive_notifications.where(visited_id: user.id, checked: false).where("created_at < ?", 1.days.ago.beginning_of_day).present?)
    end
    users_with_unckecked_notifications_mails = temp_users.pluck(:email)
    mail(from: '"Ruraloos" <noreply@yoursite.com>', subject: "通知は明日削除されます", bcc: users_with_unckecked_notifications_mails)
  end

  def high_pv_mail
    @url = "https://ruraloos.com/users/sign_in"
    temp_users = []
    Post.all.each do |post|
      temp_users << post.user if (post.impressionist_count >=100) && !(temp_users.include?(post.user)) # 重複を防いでいる
    end
    users_with_high_pv_mails = temp_users.pluck(:email)
    mail(from: '"Ruraloos" <noreply@yoursite.com>', subject: "あなたの質問が注目されています！", bcc: users_with_high_pv_mails)
  end
end
