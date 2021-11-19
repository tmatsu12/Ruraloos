class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @res1_sql = ActiveRecord::Base.connection.select_all('select name from users;')
    @res1_AR = User.all.pluck(:name)
  end
end
