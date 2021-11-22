class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @res1_sql = ActiveRecord::Base.connection.select_all('Select name From users;')
    @res1_AR = User.pluck(:name)
    @res2_sql = ActiveRecord::Base.connection.select_all('SELECT users.name, COUNT(*) FROM posts INNER JOIN users ON users.id = posts.user_id GROUP BY users.name;')
    @res2_AR = Post.joins(:user).group(:name).count
  end
end
