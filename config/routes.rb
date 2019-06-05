Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  get  '/popular',    to: 'static_pages#popular'
  get  '/recommend',   to: 'static_pages#recommend'
end
