class NewsController < ApplicationController
  def index
    require 'news-api'
    # news = News.new(ENV['NEWSAPI'])
    # @news = news.get_everything(q: '%E5%9C%B0%E6%96%B9%E7%A7%BB%E4%BD%8F', qInTitle: '%E5%9C%B0%E6%96%B9%E7%A7%BB%E4%BD%8F', sortBy: 'relevancy', pageSize: '5')
    @news = []
    require 'csv'
    @prefecture_data = CSV.read("PrefectureData.csv")
    # @initial_data = @prefecture_data[0].sort{|a,b| a.to_i <=> b.to_i }.reverse
    @prefecture_sort_data = []
    @temp_array_rank1 = []
    @temp_array_rank2 = []
    @temp_array_rank3 = []
    @temp_array_rank45 = []
    @temp_array_rank46 = []
    @temp_array_rank47 = []
    @prefecture_data.each_with_index do |pref, i|
      @prefecture_sort_data << pref.sort{|a,b| a.to_i <=> b.to_i }.reverse
      @temp_array_rank1 << Prefecture.find(pref.index(@prefecture_sort_data[i][0])).name
      @temp_array_rank2 << Prefecture.find(pref.index(@prefecture_sort_data[i][1])).name
      @temp_array_rank3 << Prefecture.find(pref.index(@prefecture_sort_data[i][2])).name
      @temp_array_rank45 << Prefecture.find(pref.index(@prefecture_sort_data[i][44])).name
      @temp_array_rank46 << Prefecture.find(pref.index(@prefecture_sort_data[i][45])).name
      @temp_array_rank47 << Prefecture.find(pref.index(@prefecture_sort_data[i][46])).name
    end
    # binding.pry
  end
end
