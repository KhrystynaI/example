Rails.application.routes.draw do
  devise_for :autors, path: 'autors', controllers: { sessions: "autors/sessions" }
  devise_for :users, path: 'users', controllers: { sessions: "users/sessions" }
  get 'welcome/index'
  get 'autors/example'
  root 'welcome#index'
  resources :articles do
  resources :comments
end
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
