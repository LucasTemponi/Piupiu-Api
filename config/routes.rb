Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: 'posts#index'
  # get '/posts', to: 'posts#index'
  # get 'posts/:id', to: 'posts#show', as: 'post'

  post '/posts', to: 'posts#create'
  post 'signup', to: 'users#create'
  post '/login', to: 'authentication#login'
  get '/pius', to: 'posts#pius'
  get '/mypius', to: 'posts#my_pius'
  get '/users/latest', to: 'users#latest_users'
  get '/users/:handle', to: 'users#show'

  resources :posts do
    member do
      get :delete
    end
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
