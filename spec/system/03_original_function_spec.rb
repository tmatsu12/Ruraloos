require 'rails_helper'

describe 'ユーザー定義メソッドのテスト' do
  # let, let!及びcreateとbuildの使い分けを意識した。
  # ランキング・通知機能関連のメソッドのテストはややこしいので保留
  let(:user) { build(:user) }
  let(:prefecture) { build(:prefecture) }
  # 9行目：letだとダメ。16,22行目でnilに対して.firstをすることになりエラーとなる
  let!(:user_prefecture) { create(:user_prefecture, user: user, prefecture: prefecture) }
  let(:post) { build(:post, user: user, prefecture: prefecture) }
  let!(:post_comment) { create(:post_comment, user: user, post: post) }
  let!(:reply) { create(:post_comment, user: user, post: post, parent_id: post_comment.id) }

  describe 'find_prefectures(status)のテスト' do
    it '中間テーブルUserPrefを介して県名を正しく表示する' do
      expect(user.find_prefectures_livepast.first.prefecture_name).to eq "北海道"
    end
  end

  describe 'find_people(status)のテスト' do
    it '中間テーブルUserPrefを介してユーザー名を正しく表示する' do
      expect(prefecture.find_people_livepast.first.user_name).to eq user.name
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
