Rails.application.routes.draw do
    # Add target for where to direct WebHook traffic
    post '/wehook', to: 'webhook#handle_payload'

    # Handle all the actions for a user
    resources :users

    # Callback for GitHub OAuth
    get '/auth/:provider/callback', to: 'sessions#create'
    get 'auth/failure' => redirect('/')
    delete '/logout', to: 'sessions#destroy'

    # Main Welcome page
    root 'welcome#index'
end
