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
      
      get '/stocks/price', to: 'stocks#price'
      get '/stocks/prices', to: 'stocks#prices'
    end
  end
end
