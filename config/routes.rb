Rails.application.routes.draw do
  root "expenses#new"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"


  resources :users
  resources :expenses, controller: :expenses
  resources :results, controller: :results
  resources :range_times
end
