Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:password]
  resources :projects do
    collection { post :sort }
  end
  root 'projects#index'
end
