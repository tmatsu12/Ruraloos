Rails.application.routes.draw do
  root 'homes#top'
  get '/about' => 'homes#about'
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "users/registrations",
    sessions: 'users/sessions'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'guest_users/sessions#guest_sign_in'
  end
  get '/region/:region' => 'homes#region', as: "region"
  resources :posts do
    resource :favorites, only: [:create, :destroy]
    collection do
      get :all_posts, as: "all"
      post :sort_all_posts, as: "sort_all"
      post :sort_prefecture_posts, as: "sort_prefecture"
    end
    resources :post_comments, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :users, only: [:show, :edit, :update] do
    member do
      post :sort, as: "sort"
    end
  end
  resource :user_prefectures, only: [:new, :create, :edit, :update]
  get '/search' => "searchs#search"
  resources :news, only: [:index]
  resources :notifications, only: [:index, :update] do
    collection do
      delete :destroy_all
    end
  end
  get 'inquiry' => 'inquiry#index'     # 入力画面
  post 'inquiry/confirm' => 'inquiry#confirm'   # 確認画面
  post 'inquiry/thanks'  => 'inquiry#thanks'    # 送信完了画面
end
