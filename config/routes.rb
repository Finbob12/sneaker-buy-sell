Rails.application.routes.draw do
  get 'errors/not_found'
  get 'errors/internal_server_error'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "listings#index"
  resources :listings
  resources :conversations do
    resources :messages
  end
  get "/account", to: "listings#account", as: "account"
  get "/payments/success", to: "payments#success"
  post "/payments/webhook", to: "payments#webhook"
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
end
