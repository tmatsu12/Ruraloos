require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '20文字以下であること：20文字は可' do
        user.name = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it '20文字以下であること：21文字は不可' do
        user.name = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
      it '一意でなくても良いこと' do
        user.name = other_user.name
        is_expected.to eq true
      end
    end

    # 7行目はletでもlet!でもOKだが、buildにするとダメになる
    # これはother_userのemailがDBに保存されていないことによる
    context 'emailカラム' do
      it '一意であること' do
        user.email = other_user.email
        is_expected.to eq false
      end
    end
  end
end
