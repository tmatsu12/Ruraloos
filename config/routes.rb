Rails.application.routes.draw do
  get 'users/show'
  get 'users/edit'
  get 'users/update'
  root 'homes#top'
  # devise_scope :user do
  #   post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  # end
  devise_for :users
  get '/region/:region' => 'homes#region', as: "region"
  resources :posts do
    resources :post_comments, only: [:new, :create, :destroy]
  end
  resources :users, only: [:show, :edit, :update]
  get 'search' => "searchs#search"
  get '/about' => 'homes#about'
end
