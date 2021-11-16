Rails.application.routes.draw do
  get 'users/show'
  root 'homes#index'

  #get 'days/home'
  resources :days,only:[:new,:create,:index] do
    collection do
      get :weight
      get :record
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }


  devise_scope :user do
    post 'users/sign_up/next', to: 'users/registrations#next'
    post 'users/sign_up/confirm', to: 'users/registrations#confirm'
    get 'users/sign_up/next', to: 'users/registrations#next' 
    get 'users/sign_up/confirm', to: 'users/registrations#confirm'
  end
end
