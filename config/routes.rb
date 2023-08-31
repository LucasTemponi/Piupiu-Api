Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: 'posts#index'
  # get '/posts', to: 'posts#index'
  # get 'posts/:id', to: 'posts#show', as: 'post'

  post 'signup', to: 'users#create'
  post '/login', to: 'authentication#login'

  get '/users/latest', to: 'users#latest_users'
  get '/users/:handle', to: 'users#show'
  patch '/users/:handle', to: 'users#update'
  get '/users/:handle/posts', to: 'users#user_posts'
  get '/users/:handle/likes', to: 'users#user_likes'

  post '/posts', to: 'posts#create'
  get '/pius', to: 'posts#pius'
  get '/mypius', to: 'posts#my_pius'

  post 'posts/:id/like', to: 'likes#create'
  get 'posts/:id/likes', to: 'likes#show'
  delete 'posts/:id/like', to: 'likes#destroy'
  post 'posts/:id/reply', to: 'replies#create'
  get 'posts/:id/replies', to: 'replies#show'
  delete 'posts/:id/reply', to: 'replies#destroy'

  resources :posts do
    resources :likes
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
