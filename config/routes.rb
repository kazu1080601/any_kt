Rails.application.routes.draw do
  devise_for :users
  resources :recommendations, only: [:index, :show, :new, :create] do
    collection do
      get 'search'
    end
  end
  root to: "recommendations#index"
end
