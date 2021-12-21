require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post.valid? }

    let(:user) { create(:user) }
    let(:prefecture) { create(:prefecture) }
    let!(:post) { build(:post, user: user, prefecture: prefecture) }

    context 'titleカラム' do
      it '空欄でないこと' do
        post.title = ''
        is_expected.to eq false
      end
      it '28文字以下であること：28文字は可' do
        post.title = Faker::Lorem.characters(number: 28)
        is_expected.to eq true
      end
      it '28文字以下であること：29文字は不可' do
        post.title = Faker::Lorem.characters(number: 29)
        is_expected.to eq false
      end
    end

    context 'bodyカラム' do
      it '空欄でないこと' do
        post.body = ''
        is_expected.to eq false
      end
      it '1000文字以下であること：1000文字は可' do
        post.body = Faker::Lorem.characters(number: 1000)
        is_expected.to eq true
      end
      it '1000文字以下であること：1001文字は不可' do
        post.body = Faker::Lorem.characters(number: 1001)
        is_expected.to eq false
      end
    end
  end
end
