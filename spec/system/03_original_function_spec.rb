require 'rails_helper'

describe 'ユーザー定義メソッドのテスト' do # ランキング・通知機能関連のメソッドのテストは断念した
  let!(:user) { create(:user) }
  let!(:prefecture) { create(:prefecture) }
  let!(:user_prefecture) { create(:user_prefecture, user: user, prefecture: prefecture) }
  let!(:post) { create(:post, user: user, prefecture: prefecture) }
  let!(:post_comment) { create(:post_comment, user: user, post: post) }
  let!(:reply) { create(:post_comment, user: user, post: post, parent_id: post_comment.id) }

  describe 'find_prefectures(status)のテスト' do
    it '中間テーブルUserPrefを介して県名を正しく表示する' do
      expect(user.find_prefectures(0).first.prefecture_name).to eq "北海道"
    end
  end

  describe 'find_people(status)のテスト' do
    it '中間テーブルUserPrefを介してユーザー名を正しく表示する' do
      expect(prefecture.find_people(0).first.user_name).to eq user.name
    end
  end

  describe 'be_reply?のテスト' do
    it '回答に対する返信であるか確認する' do
      expect(reply.be_reply?).to eq true
    end
  end

  describe 'replies?のテスト' do
    it '回答が返信を持っているか確認する' do
      expect(post_comment.replies?).to eq true
    end
  end
end
# ランキング・通知機能関連のメソッドのテストは断念した