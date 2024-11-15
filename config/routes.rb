Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :session, only: [:create, :destroy]
      
      resources :wallets, only: [:show] do
        get :balance, on: :member
      end
      
      resources :transactions, only: [:create, :index]
      
      resources :stocks, only: [] do
        collection do
          get :price
          get :prices
          get :price_all
        end
      end
    end
  end
end
