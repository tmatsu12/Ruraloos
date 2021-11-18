class Batch::DataReset
  def self.notifications_clear
    Notification.where("created_at < ?", 20.days.ago.beginning_of_day).delete_all
  end

  def self.guest_introduction_clear
    User.where(name: "ゲスト").update(introduction: "")
  end
end
