Rails.application.routes.draw do
  devise_for :users
  resources :recommendations, only: [:index, :show, :new, :create] do
    collection do
      get 'search'
      get 'root'
    end
  end
  root to: "recommendations#root"
end
