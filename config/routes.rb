Rails.application.routes.draw do

  devise_for :users
  root to: 'phrases#index'
  get 'static_pages/hello'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: [:show, :index]

  resources :phrases do
    member do
      post :vote
    end
    resources :examples, only: [:create, :destroy] do
      post :vote
    end
  end

  resources :notifications, only: [:index] do
    collection do
      put :read_all
    end
  end


end
