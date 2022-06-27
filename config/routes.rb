Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Set custom paths.
  root to: 'static_page#home'
  get 'api_doc', to: 'static_page#api_doc'
  get 'documentation', to: 'static_page#documentation'
  # Set paths for API keys.
  resources :users, only: %i[index new edit create update destroy]
  resources :douyin_accounts, only: %i[index new edit create update destroy]
  resources :videos, only: %i[index]
  resources :kaogu_productions, only: %i[index]

  # Set paths for the API.
  namespace :api do
    get 'run_key', to: 'run_keys#run_key'
    get 'kaogu_run_key', to: 'run_keys#kaogu_run_key'
    post 'update_runkey_status', to: 'run_keys#update_runkey_status'
    post 'update_kaogu_status', to: 'run_keys#update_kaogu_status'
  end
end
