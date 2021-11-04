class NewsController < ApplicationController
  def index
    require 'news-api'
    news = News.new(ENV['NEWSAPI'])
    @news = news.get_everything(q: '%E5%9C%B0%E6%96%B9%E7%A7%BB%E4%BD%8F', qInTitle: '%E5%9C%B0%E6%96%B9%E7%A7%BB%E4%BD%8F', sortBy: 'relevancy', pageSize: '5')
  end
end
