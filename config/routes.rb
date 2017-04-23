Rails.application.routes.draw do
  resources :users, :only => [:show, :update], :path => "u"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:password]
  resources :projects do
    collection do
      post "/metrics_on_date", :to => "projects#metrics_on_date"
      get "/metrics_on_date_v2", :to => "projects#metrics_on_date_v2"
      get '/show_metric', :to => 'projects#show_metric'
    end
  	member do
  		post "/add_owner", :to => "projects#add_owner"
  	end
  end

  root 'projects#new_index'
  resources :whitelists

  get '/application/update_all_projects/', :to => 'application#update_all_projects', :as => 'update_all_projects'

  get '/login/:id', :to => 'application#passthru', :as => 'passthru'

  get '/whitelists/upgrade/:id', :to => 'whitelists#upgrade', :as => 'upgrade_user'
  get '/whitelists/downgrade/:id', :to => 'whitelists#downgrade', :as => 'downgrade_user'

  get '/dev', :to => 'projects#new_index', :as => 'new_index'
  get 'all_metrics/:id', :to => 'projects#all_metrics', :as => 'all_metrics'
  get 'projects/:id/metrics/:metric', :to => 'projects#get_metric_data'
  get '/charts', :to => 'projects#charts'

end
