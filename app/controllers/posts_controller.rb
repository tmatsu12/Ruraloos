class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy], notice: "ログインしてください（ゲストログインが便利です）"
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @user = current_user
    @prefecture = Prefecture.find(params[:prefecture_id])
    @posts = @prefecture.posts.page(params[:page]).order(updated_at: :desc)
    @residents = @prefecture.residents
    @wannalivings = @prefecture.wannalivings
  end

  def all_posts
    @posts = Post.all.page(params[:page]).order(updated_at: :desc).per(25)
  end

  def sort
    if params[:option].to_i == 1
      @posts = Post.all.page(params[:page]).order(updated_at: :desc).per(25)
    else
      @posts = Kaminari.paginate_array(Post.find(Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))).page(params[:page]).per(25)
    end
    render :all_posts
  end

  def new
    if user_signed_in?
      @post = Post.new
      @user = current_user
    else
      flash[:notice] = "ログインして下さい（ゲストログインが便利です！）"
      redirect_to new_user_session_path
    end
  end

  def show
    #投稿を詳細ページで削除後マイページに飛ぶが、そこから左上の戻るボタンで詳細ページに戻るとエラーになってしまうのでその対策で例外処理
    begin
      @post = Post.find(params[:id])
      @post_comment = PostComment.new
      @prefecture = @post.prefecture
      @user = @post.user
      @address = @post.prefecture.name + @post.city
      begin
        results = Geocoder.search(@address)
        @latlng = results.first.coordinates
      rescue
        @latlng = [40.7828, -73.9653] #おかしな地名が入力された場合はNewYorkを表示
        flash[:notice] = "#{@prefecture.name}内の市町村ですか？市町村名を間違っていませんか？"
      end
    rescue
      redirect_to all_posts_path
    end
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
    params.require(:post).permit(:title, :city, :body, :prefecture_id, :image, :evaluation, :body1, :body2, :body3)
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    if @post.user != current_user
      flash[:notice] = "他のユーザーの情報は変更できません"
      redirect_to user_path(current_user)
    end
  end
end
