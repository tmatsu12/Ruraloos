require 'rails_helper'

describe 'ユーザー定義メソッドのテスト' do
  # let, let!及びcreateとbuildの使い分けを意識した
  # 通知機能関連やソート機能関連のメソッドのテストはややこしいので保留
  let(:user) { build(:user) }
  let(:prefecture) { build(:prefecture) }
  # 9行目：letだとダメ。findのテストの左辺でnilに対して.firstをすることになりエラーとなる
  let!(:user_prefecture) { create(:user_prefecture, user: user, prefecture: prefecture) }
  let(:post) { create(:post, user: user, prefecture: prefecture) }
  let!(:post_comment) { create(:post_comment, user: user, post: post) }
  let!(:reply) { create(:post_comment, user: user, post: post, parent_id: post_comment.id) }

  describe 'Userモデルのメソッドのテスト' do
    describe 'find_prefectures_livepastのテスト' do
      it '中間テーブルUserPrefectureを介して県名を正しく表示する' do
        expect(user.find_prefectures_livepast.first.prefecture_name).to eq "北海道"
      end
    end

    describe 'create_user_prefecture_by_status!のテスト' do
      it '複数の住んだことのある県を正しく保存できるか確認する' do
        n = 3
        # create_listで生成されるインスタンスは一意とは限らないのでたまに失敗する
        ids = create_list(:prefecture, n).map(&:id)
        user.create_user_prefecture_by_status!(ids, 'livepast')
        expect(UserPrefecture.count).to eq (n + 1)
      end
    end

    describe 'create_user_prefecture!のテスト' do
      it '複数の住んだことのある県を正しく保存できるか確認する' do
        n = 3
        # create_listで生成されるインスタンスは一意とは限らないのでたまに失敗する
        ids = create_list(:prefecture, n).map(&:id)
        user.create_user_prefecture!(prefecture_livepast_ids: ids, prefecture_livefuture_ids:[])
        expect(UserPrefecture.livepast.count).to eq (n + 1)
      end
    end

    describe 'create_user_prefecture!のテスト' do
      it '複数の住んでみたい県を正しく保存できるか確認する' do
        n = 3
        # create_listで生成されるインスタンスは一意とは限らないのでたまに失敗する
        ids = create_list(:prefecture, n).map(&:id)
        user.create_user_prefecture!(prefecture_livepast_ids: [], prefecture_livefuture_ids:ids)
        expect(UserPrefecture.livefuture.count).to eq n
      end
    end
  end

  describe 'Postモデルのメソッドのテスト' do
    describe 'search_forのテスト' do
      it '完全一致による検索が正しくできるか確認する' do
        expect(Post.search_for("", prefecture.id, 'perfect').first.prefecture_id).to eq post.prefecture.id
      end
    end

    describe 'search_forのテスト' do
      it '部分一致による検索が正しくできるか確認する' do
        expect(Post.search_for(post.city.slice(0,1), prefecture.id, 'partial').first.city).to eq post.city
      end
    end
  end

  describe 'Prefectureモデルのメソッドのテスト' do
    describe 'find_people_livepastのテスト' do
      it '中間テーブルUserPrefectureを介してユーザー名を正しく表示する' do
        expect(prefecture.find_people_livepast.first.user_name).to eq user.name
      end
    end
  end

  describe 'PostCommentモデルのメソッドのテスト' do
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
end
