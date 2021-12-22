require 'rails_helper'

describe 'ユーザー定義メソッドのテスト' do
  # let, let!及びcreateとbuildの使い分けを意識した
  # 通知機能関連のメソッドのテストはややこしいので保留
  let(:user) { build(:user) }
  let(:prefecture) { build(:prefecture) }
  # 9行目：letだとダメ。findのテストの左辺でnilに対して.firstをすることになりエラーとなる
  let!(:user_prefecture) { create(:user_prefecture, user: user, prefecture: prefecture) }
  let(:post) { build(:post, user: user, prefecture: prefecture) }
  let!(:post_comment) { create(:post_comment, user: user, post: post) }
  let!(:reply) { create(:post_comment, user: user, post: post, parent_id: post_comment.id) }

  describe 'find_prefectures_livepastのテスト' do
    it '中間テーブルUserPrefectureを介して県名を正しく表示する' do
      expect(user.find_prefectures_livepast.first.prefecture_name).to eq "北海道"
    end
  end

  describe 'find_people_livepastのテスト' do
    it '中間テーブルUserPrefectureを介してユーザー名を正しく表示する' do
      expect(prefecture.find_people_livepast.first.user_name).to eq user.name
    end
  end

  describe 'create_user_prefecture_by_status!のテスト' do
    it '複数のuser_prefectureインスタンスを正しく保存できるか確認する' do
      n = 5
      # create_listで生成されるインスタンスは一意とは限らないのでたまに失敗する
      ids = create_list(:prefecture, n).map(&:id)
      user.create_user_prefecture_by_status!(ids, 'livepast')
      expect(UserPrefecture.count).to eq (n + 1)
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
