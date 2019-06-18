Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/popular',    to: 'static_pages#popular'
  get    '/recommend',  to: 'static_pages#recommend'
  get    '/signup',     to: 'users#new'
  get    '/login',      to: 'sessions#new'
  post   '/login',      to: 'sessions#create'
  delete '/logout',     to: 'sessions#destroy'
  resources :users
  resources :videos
end
