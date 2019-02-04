Rails.application.routes.draw do
  get 'favorites/update'
  get 'messages/create'
  devise_for :autors, path: 'autors', controllers: { sessions: 'autors/sessions', registrations: 'autors/registrations' }
  devise_for :users, path: 'users', controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  get 'welcome/index'
  get 'autors/for_autor'
  get 'autors/charts'
  root 'welcome#index'
  get 'articles/index_for_autor'
  post 'messages', to:"messages#create"
  resources :articles do
    member do
      delete :delete_upload
  end
    resources :comments
  end


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
