Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/health', to: 'health#show'
      
      post '/session', to: 'sessions#create'
      delete '/session', to: 'sessions#destroy'
      
      resources :wallets, only: [:show] do
        member do
          get :balance
        end
      end
      
      resources :transactions, only: [:index, :create]
      
      resources :stocks, only: [] do
        collection do
          get 'price'
          get 'price_all'
          get 'search'
          get 'enhanced'
          get 'timeseries'
        end
      end
    end
  end
end
