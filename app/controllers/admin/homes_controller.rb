class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @res1_sql = ActiveRecord::Base.connection.select_all('Select name From users;')
    @res1_AR = User.pluck(:name)
    @res2_sql = ActiveRecord::Base.connection.select_all('SELECT users.name, COUNT(*) FROM posts INNER JOIN users ON users.id = posts.user_id GROUP BY users.name;')
    @res2_AR = Post.joins(:user).group("users.name").count
    @res3_sql = ActiveRecord::Base.connection.select_all('SELECT users.name, COUNT(*) FROM posts INNER JOIN users ON users.id = posts.user_id GROUP BY users.name ORDER BY COUNT(*) DESC;')
    @res3_AR = Post.joins(:user).group("users.name").order("count_all desc").count
    @res4_sql = ActiveRecord::Base.connection.select_all('SELECT posts.id, COUNT(*) FROM posts INNER JOIN favorites ON favorites.post_id = posts.id GROUP BY posts.id ORDER BY COUNT(*) DESC;')
    @res4_AR = Post.joins(:favorites).group("posts.id").order("count_all desc").count
    @res5_sql = ActiveRecord::Base.connection.select_all('SELECT prefectures.name, COUNT(*) FROM prefectures INNER JOIN user_prefectures ON user_prefectures.prefecture_id = prefectures.id WHERE user_prefectures.status = 1 GROUP BY prefectures.name ORDER BY COUNT(*) DESC LIMIT 3;')
    @res5_AR = Prefecture.joins(:user_prefectures).where("user_prefectures.status": "livefuture").group("prefectures.name").order("count_all desc").limit(3).count
  end
end
