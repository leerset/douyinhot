Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Set custom paths.
  root to: 'static_page#home'
  get 'api_doc', to: 'static_page#api_doc'
  get 'documentation', to: 'static_page#documentation'
  # Set paths for API keys.
  resources :users, only: %i[index new edit create update destroy]
  resources :apps, only: %i[index new edit create update destroy]
  resources :category_formulas, only: %i[index show new edit create update destroy]

  resources :groups, only: %i[index new edit create update destroy]
  resources :categories, only: %i[index show new edit create update destroy]
  resources :categories do
    get :index_up, :index_down
  end
  resources :category_requests, only: %i[index new edit create update destroy]
  resources :resolution_requests, only: %i[index new edit create update destroy]
  resources :api_manages, only: %i[index new edit create update destroy]

  # Set paths for the API.
  namespace :api do
    namespace :v1 do
      get 'download', to: 'category#download'
      get 'calculate', to: 'resolution#calculate'
    end
  end

end
