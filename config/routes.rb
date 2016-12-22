Rails.application.routes.draw do
  devise_for :customers
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 root 'customers_seeking_posts#index'
 match 'user_root' => 'customers#index', :via => [:get], :as => :user_root
 #root 'dashboard#index'
 resources :customers, only: [ :index, :show, :update ]
 resources :customers_seeking_posts, only: [:index, :show ]
 resources :posts, only: [:index, :show, :new, :create, :update ]
 resources :categories, only: [:index]
 resources :cities, only: [:index]

 get "seeking_matview", to: "seeking_matview#index"
 get "angular_test", to: "angular_test#index"
 get "fake_billing", to: "fake_billing#show"
end
