require 'rails_helper'

describe 'ユーザーログイン前のテスト' do
  describe 'ユーザー新規登録のテスト' do
    let(:user) { build(:user) }

    before do
      visit new_user_registration_path
      fill_in 'user[name]', with: user.name
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      fill_in 'user[password_confirmation]', with: user.password_confirmation
    end

    context '新規登録成功のテスト' do
      it '正しく新規登録される' do
        expect { click_button "新規登録" }.to change { User.count }.by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
  end

  describe 'ユーザログインのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザー認証のテスト' do
    let(:prefecture) { build(:prefecture) }
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user, prefecture: prefecture) }

    context 'ユーザー認証失敗のテスト' do
      it '新規質問ページにアクセスできなく、ログイン画面にリダイレクトされる' do
        visit new_post_path
        expect(current_path).to eq '/users/sign_in'
      end
      it '質問編集ページにアクセスできなく、ログイン画面にリダイレクトされる' do
        visit edit_post_path(post.id)
        expect(current_path).to eq '/users/sign_in'
      end
      it 'ユーザー詳細ページにアクセスできなく、ログイン画面にリダイレクトされる' do
        visit user_path(user.id)
        expect(current_path).to eq '/users/sign_in'
      end
      it 'ユーザー編集ページにアクセスできなく、ログイン画面にリダイレクトされる' do
        visit edit_user_path(user.id)
        expect(current_path).to eq '/users/sign_in'
      end
      it '新規県登録ページにアクセスできなく、ログイン画面にリダイレクトされる' do
        visit new_user_prefectures_path
        expect(current_path).to eq '/users/sign_in'
      end
      it '県編集ページにアクセスできなく、ログイン画面にリダイレクトされる' do
        visit edit_user_prefectures_path
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      click_on 'ログアウト'
    end

    context 'ログアウト機能のテスト' do
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end
