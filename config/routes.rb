Rails.application.routes.draw do

  # Nexmo Voice Api routes
  get 'nexmo-answer', to: 'api/nexmo#answer'
  get 'nexmo-events', to: 'api/nexmo#events'
  post 'nexmo-events', to: 'api/nexmo#events'
  get 'nexmo-fallback', to: 'api/nexmo#fallback'


  namespace :api do
    resources :conversations, only: [:index, :destroy]
    resources :open_tok_connections, only: [:create, :destroy, :index]
    resources :open_tok_sessions, only: [:create, :index, :show, :destroy]
    resources :open_tok_tokens, only: [:create]
    resources :open_tok_streams, only: [:index, :show, :destroy]
    resources :phone_calls, only: [:create, :destroy]
  end
end
