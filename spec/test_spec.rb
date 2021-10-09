require 'rails_helper'

# 基本的にlet!とcreateで統一するが、必要に応じてbuildを使う

describe 'エラー①：ユーザー新規登録のテスト' do
  let(:user) { build(:user) }

  before do
    visit new_user_registration_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    fill_in 'user[password_confirmation]', with: user.password_confirmation
  end

  context '新規登録成功のテスト' do
    it '外部キー入力を求められることなく正しく新規登録される' do
      expect { click_button "新規登録" }.to change{ User.count }.by(1)
    end
  end
end