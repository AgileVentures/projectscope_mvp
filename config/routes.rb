Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:password]
  resources :comments
  resources :users, :only => [:show, :update] do
    member do
      get 'init', to: 'users#init_new'
      patch 'init', to: 'users#init_update'
    end
  end
  resources :projects do
    member do
      post "/add_owner", to: "projects#add_owner"
      get '/metrics/:metric', to: 'projects#get_metric_data'
      get '/metrics/:metric/series', to: 'projects#get_metric_series'
      get '/metrics/:metric/detail', to: 'projects#show_metric'
      get '/metrics/:metric/report', to: 'projects#show_report'
    end
  end
  resources :whitelists, :only => [:index] do
    member do
      put 'upgrade', to: 'whitelists#upgrade'
      put 'downgrade', to: 'whitelists#downgrade'
    end
  end
  resources :metric_samples, only: [:index] do
    member do
      get '/:metric/series', to: 'projects#get_metric_series'
      get '/:metric/detail', to: 'projects#show_metric'
      get '/:metric/report', to: 'projects#show_report'
      get 'raw_data'
    end
  end

  get '/metric_samples/:metric_sample_id/comments',
      :to => 'comments#comments_for_metric_sample',
      :as => 'metric_sample_comments'

  resources :tasks
  resources :iterations

  get '/iteration_task/:iteration_id/task/:task_id',
      to: 'iterations#iteration_task'
  get '/iteration_task_reset/:iteration_id/task/:task_id',
      to: 'iterations#iteration_task_reset', as: 'iteration_task_reset'
  get '/iterations/:iteration_id/delete_task/:task_id',
       to: 'iterations#delete_task', as: 'iteration_delete_task'
  get '/login/:id', to: 'application#passthru', as: 'passthru'
  post '/log', to: 'projects#write_log'
  post 'iterations/update_all',
       to: 'iterations#update_all', as: 'update_all_tasks'
  post 'iterations/create_task',
       to: 'iterations#create_task', as: 'create_task'
  post 'iterations/create_template_task',
       to: 'iterations#create_template_task', as: 'create_template_task'
  get 'aggregate_tasks_graph', to: 'iterations#aggregate_tasks_graph'
  post '/iterations/apply_to_all', to: 'iterations#apply_to_all'
  post 'event/:callback_token/callback', to: "tasks#call_back_handler"
  post 'iterations/:id/apply_to', to: "iterations#apply_to", as: 'iteration_apply'
  get  'iterations/:id/show_template', to: "iterations#show_template", as: 'show_iter_temp'
  get  'iterations/:id/select_projects', to: "iterations#select_projects", as: 'iter_select_projs'
  get 'iterations/:id/delete_iteration', to: "iterations#delete_iteration", as: 'delete_iteration'
  post 'iterations/:id/confirm_assignment', to: "iterations#confirm_assignment", as: 'iter_confirm_info'
  get '/dashboard', to: "iterations#dashboard"
  root 'projects#index'
end
