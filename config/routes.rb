Plain::Engine.routes.draw do

  root 'home#index'

  resources :conversations do
    member do
      put :pin
    end
    resources :messages
  end

  get '/docs/*file_path', to: 'docs#show', as: :docs
  get '/docs/', to: 'docs#show'
end
