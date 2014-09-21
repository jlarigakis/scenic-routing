ScenicRouting::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :locations do
    get 'search', on: :collection
  end
end
