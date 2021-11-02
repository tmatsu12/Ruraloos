Rails.application.routes.draw do
  root 'homes#top'
  get '/about' => 'homes#about'
  devise_for :users
  devise_scope :user do
    post 'users/guest_sign_in', to: 'guest_users/sessions#guest_sign_in'
  end
  get '/region/:region' => 'homes#region', as: "region"
  resources :posts do
    resource :favorites, only: [:create, :destroy]
    collection do
      get :all_posts
    end
    resources :post_comments, only: [:new, :create, :destroy]
  end
  resources :users, only: [:show, :edit, :update]
  get 'search' => "searchs#search"
  resources :notifications, only: [:index, :update]
end
