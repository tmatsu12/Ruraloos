# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# 絶対パスから相対パス指定
env :PATH, ENV['PATH']
# ログファイルの出力先
set :output, 'log/cron.log'
# ジョブの実行環境の指定
set :environment, :production
#
every 1.minutes do ##ここを追加
# every 1.days, at: '9:00 am' do　##ここをコメントアウト

# Rails内のメソッド実行
  runner "ScheduledProcessingMailer.check_notice_mail.deliver_now"
end

# Learn more: http://github.com/javan/whenever
