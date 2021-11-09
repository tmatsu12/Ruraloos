require 'rails_helper'

describe 'ユーザーログイン後のテスト' do
  let!(:user) { create(:user) }
  let!(:prefecture) { create(:prefecture) }
  let!(:post) { create(:post, user: user, prefecture: prefecture) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe '新規質問するテスト' do
    before do
      visit new_post_path
      fill_in 'post[title]', with: Faker::Lorem.characters(number: 5)
      select prefecture.name, from: 'post[prefecture_id]'
      fill_in 'post[body]', with: Faker::Lorem.characters(number: 5)
    end

    context '新規質問成功のテスト' do
      it '新規質問が正しく保存される' do
        expect { click_button '質問する' }.to change { Post.count }.by(1)
      end
      it 'リダイレクト先が、保存できた質問の詳細画面になっている' do
        click_button '質問する'
        expect(current_path).to eq '/posts/' + Post.last.id.to_s
      end
    end
  end

  describe '質問を編集するテスト' do
    before do
      visit edit_post_path(post)
      @post_old_title = post.title
      @post_old_prefecture = prefecture.id
      @post_old_body = post.body
      fill_in 'post[title]', with: Faker::Lorem.characters(number: 5)
      fill_in 'post[body]', with: Faker::Lorem.characters(number: 5)
      click_button '更新する'
    end

    context '編集成功のテスト' do
      it 'titleが正しく更新される' do
        expect(post.reload.title).not_to eq @post_old_title
      end
      it 'bodyが正しく更新される' do
        expect(post.reload.body).not_to eq @post_old_body
      end
      it 'リダイレクト先が、更新した質問の詳細画面になっている' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
    end
  end

  describe '質問に対して回答するテスト' do
    before do
      visit post_path(post)
      fill_in 'post_comment[comment]', with: Faker::Lorem.characters(number: 10)
    end

    context '回答成功のテスト', js: true do
      it '回答が正しく保存される' do
        expect { click_button '回答する' }.to change { PostComment.count }.by(1)
      end
    end
  end
end
