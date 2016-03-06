Rails.application.routes.draw do

    # Add target for where to direct WebHook traffic
    scope '/webhook', :controller => :webhook do
        post :handle_payload
    end
end
