Rails.application.routes.draw do
  get 'users/show'
  root 'homes#index'

  resources :energys, only:[:new, :create, :index] do
    collection do
      post :weight
      get :record
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }


  devise_scope :user do
    post 'users/sign_up/next', to: 'users/registrations#next'
    post 'users/sign_up/confirm', to: 'users/registrations#confirm'
    get 'users/sign_up/complete', to: 'users/registrations#complete'
    get 'users/sign_up/exception', to: 'users/registrations#exception'
  end
end
