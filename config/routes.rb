Plain::Engine.routes.draw do

  root 'home#index'

  resources :conversations do
    member do
      put :pin
    end
    resources :messages do
      resources :documents
    end
  end

  get '/docs/*file_path', to: 'docs#show', as: :docs
  get '/docs/', to: 'docs#show'
  get '/doc_editor/*file_path', to: 'docs#edit', as: :edit_doc
  put '/doc_editor/*file_path', to: 'docs#update', as: :update_doc

end
