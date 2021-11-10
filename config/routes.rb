Rails.application.routes.draw do
  devise_for :users
  root 'homes#index'

  devise_scope :user do
    post 'users/sign_up/next', to: 'users/registrations#next'
    post 'users/sign_up/confirm', to: 'users/registrations#confirm'
  end
end
