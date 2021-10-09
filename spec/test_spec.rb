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

describe 'エラー②：フレンドリーフォワーディングの確認（新規登録・ログイン後の画面遷移先のテスト）' do
  let!(:prefecture) { create(:prefecture) } # !がないとindex pageのidとnew pageのURLのidが一致しない？(prefecture.id = within(35..38)とした時) → そんなことはなかった

  before do
    visit '/posts?prefecture_id=' + prefecture.id.to_s
    click_link "新規に投稿する"
  end

  context '新規投稿を押下後に新規登録した場合' do
    let(:user) { build(:user) }

    before do
      click_link '新規登録'
      fill_in 'user[name]', with: user.name
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      fill_in 'user[password_confirmation]', with: user.password_confirmation
      click_button "新規登録"
    end

    it '新規登録後に新規投稿画面に遷移する' do
      expect(current_path).to eq '/posts/new?prefecture_id=' + prefecture.id.to_s
      # expect(current_path).to eq "/"
    end
  end

  context '新規投稿を押下後に簡単ログインした場合' do
    let(:user) { create(:user) }

    before do
      click_link "簡単ログイン"
    end

    it '簡単ログイン後に新規投稿画面に遷移する' do
      expect(current_path).to eq '/posts/new?prefecture_id=' + prefecture.id.to_s
    end
  end

  context '新規投稿を押下後にログインした場合' do
    let!(:user) { create(:user) }

    before do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button "ログイン"
    end

    it 'ログイン後に新規投稿画面に遷移する' do
      expect(current_path).to eq '/posts/new?prefecture_id=' + prefecture.id.to_s
    end
  end
end

describe 'エラー③：１回エラーになってからもう一度新規投稿するテスト' do
  let!(:prefecture) { create(:prefecture) }
  let!(:user) { create(:user) }
  let(:post) { build(:post, user_id: user.id) }

  before do
    visit new_user_session_path # 投稿前にログインが必要
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button "ログイン"
  end