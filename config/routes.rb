Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Set custom paths.
  root to: 'static_page#home'
  get 'api_doc', to: 'static_page#api_doc'
  get 'documentation', to: 'static_page#documentation'
  # Set paths for API keys.
  resources :users, only: %i[index new edit create update destroy]

end
