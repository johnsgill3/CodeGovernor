class WebhookController < ApplicationController
    skip_before_action :verify_authenticity_token

    def handle_payload
        @payload = params[:payload]

        # Make sure that this hook came from a known repo
        verify_signature(request.body.read)

        case request.env['HTTP_X_GITHUB_EVENT']
            when "pull_request"
                if @payload["action"] == "opened"
                    puts "Received: pull_request[opened]"
                elsif @payload["action"] == "synchronized"
                    puts "Received: pull_request[synchronized]"
                elsif @payload["action"] == "closed"
                    puts "Received: pull_request[closed]"
                elsif @payload["action"] == "reopened"
                    puts "Received: pull_request[reopened]"
                end
            when "issue_comment"
                puts "Received: issue_comment"
            when "ping"
                puts "Received: ping"
                # Send initial status message so Protected Branch can be setup
            else
                puts "Received: Unknown Event"
                # Should this be an error? Got something we don't know how to handle
        end
        # For now don't send anything in body of message.
        # In future might add status message here
        render :nothing => true
    end

    def verify_signature(payload_body)
        # TODO: Create Secret Key for each repo. Store in DB
        signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['WEBHOOK_SECRET_KEY'], payload_body)
        return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
    end
end
