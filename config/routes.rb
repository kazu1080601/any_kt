Rails.application.routes.draw do
  devise_for :users
  get 'recommendations/index'
  root to: "recommendations#index"
end
