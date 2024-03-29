class PostsController < ApplicationController
  include PostsHelper
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @prefecture = Prefecture.find(params[:prefecture_id])
    session[:prefecture_id] = params[:prefecture_id] # sort_prefecture_postsアクションで使うため
    @posts = @prefecture.posts.includes(:user).page(params[:page]).order(updated_at: :desc)
    @residents = @prefecture.find_people_livepast # prefecture.rbで定義
    @wannalivings = @prefecture.find_people_livefuture # 同上
  end

  def all_posts
    @posts = Post.all.includes(:prefecture, :user).page(params[:page]).order(updated_at: :desc).per(25)
  end

  def sort_all_posts
    # sort_postsメソッドはposts_helper.rbに定義
    if sort_posts(params[:option]).class == Array
      @posts = Kaminari.paginate_array(sort_posts(params[:option])).page(params[:page]).per(25)
    else
      @posts = sort_posts(params[:option]).page(params[:page]).per(25)
    end
    render :all_posts
  end

  def sort_prefecture_posts
    @prefecture = Prefecture.find(session[:prefecture_id])
    @residents = @prefecture.find_people_livepast
    @wannalivings = @prefecture.find_people_livefuture
    # sort_pref_postsメソッドはprefecture.rbに定義
    if @prefecture.sort_pref_posts(params[:option]).class == Array
      @posts = Kaminari.paginate_array(@prefecture.sort_pref_posts(params[:option])).page(params[:page]).per(25)
    else
      @posts = @prefecture.sort_pref_posts(params[:option]).page(params[:page]).per(25)
    end
    render :index # sessionでprefecture_idの情報は保持している
  end

  def new
    @post = Post.new
    @user = current_user
    redirect_to new_user_session_path, flash: { notice: "ログインして下さい（ゲストログインが便利です！）" } unless user_signed_in?
  end

  def show
    @post = Post.find(params[:id])
    impressionist(@post, nil, :unique => [:session_hash.to_s])
    @page_views = @post.impressionist_count
    @post_comment = PostComment.new
    @prefecture = @post.prefecture
    @user = @post.user
    @address = @post.prefecture_name + @post.city
    begin
      results = Geocoder.search(@address)
      @latlng = results.first.coordinates
    rescue
      @latlng = [40.7828, -73.9653] # おかしな地名が入力された場合はNewYorkを表示
      flash[:notice] = "#{@prefecture.name}内の市町村ですか？市町村名を間違っていませんか？"
    end
    # 投稿を詳細ページで削除してマイページに飛んだ後、左上の戻るボタンで
    # 詳細ページに戻りリロードするとエラーになるのでその対策が必要
    # これは例外処理のbegin/endを省略できるケースに当たる
    rescue
      redirect_to all_posts_path
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post)
    else
      @user = current_user
      render :new
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
    @user = @post.user
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post)
      flash[:notice] = "投稿を更新しました"
    else
      @user = @post.user
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(@post.user)
  end

  private

  def post_params
    params.require(:post).permit(:title, :city, :body, :prefecture_id)
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    redirect_to user_path(current_user), flash: { notice: "他のユーザーの情報は変更できません" } if !current_user.be_identical?(@post.user)
  end
end
