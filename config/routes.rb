Rails.application.routes.draw do
  get 'users/show'
  root 'homes#index'

  resources :energys do
    member do
      get :list
      post :list
      get :record
    end
  end
  
  resources :days do
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    post 'users/sign_up/next', to: 'users/registrations#next'
    post 'users/sign_up/confirm', to: 'users/registrations#confirm'
    get 'users/sign_up/complete', to: 'users/registrations#complete'
    get 'users/sign_up/exception', to: 'users/registrations#exception'
    get 'users/:id/edit_password', to: 'users/registrations#edit_password', as: 'edit_password'
    put 'users/:id/update_password', to: 'users/registrations#update_password', as: 'update_password'
  end
end
