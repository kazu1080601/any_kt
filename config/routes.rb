Rails.application.routes.draw do
  get 'recommendations/index'
  root to: "recommendations#index"
end
