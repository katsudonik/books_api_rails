Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :books
  resources :users, only: [:index, :show, :update]
  resources :favorite_books, param: :book_id, only: [:index, :create] do
    member do
      delete '/', to: 'favorite_books#destroy'
    end
  end
  resources :chat_messages, only: [:index]
  mount ActionCable.server => '/cable'
end
