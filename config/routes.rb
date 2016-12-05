Rails.application.routes.draw do
  resources :users, :only => [:show, :update], :path => "u"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:password]

  resources :projects
  root 'projects#index'
  resources :whitelists

  get '/whitelists/upgrade/:id', :to => 'whitelists#upgrade', :as => 'upgrade_user'
  get '/whitelists/downgrade/:id', :to => 'whitelists#downgrade', :as => 'downgrade_user'
  
end
