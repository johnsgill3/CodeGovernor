Rails.application.routes.draw do
  root 'welcome#index'

  # Callback for GitHub OAuth
  get '/auth/:provider/callback', to: 'sessions#create'
end
