require 'sidekiq/web'

Rails.application.routes.draw do
  
  match "users/unsubscribe/:unsubscribe_hash", to: "emails#unsubscribe", as: :unsubscribe, via: :all

  resources :projects do 
    resources :tasks
  end
    
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users

  devise_scope :user do 
    authenticated :user do 
      root 'projects#index'
    end

    unauthenticated :user do 
      root "home#index", as: :unauthenticated_root
    end
  end

end
