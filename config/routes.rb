Rails.application.routes.draw do

    # Add target for where to direct WebHook traffic
    post '/wehook', to: 'webhook#handle_payload'
end
