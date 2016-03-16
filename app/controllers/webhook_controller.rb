class WebhookController < ApplicationController
    skip_before_action :verify_authenticity_token

    def handle_payload
        @payload = params[:payload]
        @payload_body = request.body.read

        # Make sure that this hook came from a known repo
        verify_signature(@payload_body)

        case request.env['HTTP_X_GITHUB_EVENT']
            when "pull_request"
                if @payload["action"] == "opened"
                    logger.debug "WHC Received: pull_request[opened]"
                elsif @payload["action"] == "synchronized"
                    logger.debug "WHC Received: pull_request[synchronized]"
                elsif @payload["action"] == "closed"
                    logger.debug "WHC Received: pull_request[closed]"
                elsif @payload["action"] == "reopened"
                    logger.debug "WHC Received: pull_request[reopened]"
                else
                    logger.debug "WHC Received: pull_request[Unknown action]"
                end
            when "issue_comment"
                logger.debug "WHC Received: issue_comment"
            when "ping"
                logger.debug "WHC Received: ping"
                # Send initial status message so Protected Branch can be setup
            else
                logger.debug "WHC Received: Unknown Event"
                # Should this be an error? Got something we don't know how to handle
        end
        # For now don't send anything in body of message.
        # In future might add status message here
        render plain: "Received #{request.env['HTTP_X_GITHUB_EVENT']} Event"
    end

    def verify_signature(payload_body)
        # TODO: Create Secret Key for each repo. Store in DB
        signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['WEBHOOK_SECRET_KEY'], payload_body)
        return halt 500, "Signatures didn't match!" unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
    end
end
