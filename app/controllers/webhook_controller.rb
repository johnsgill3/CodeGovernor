class WebhookController < ApplicationController
    skip_before_action :verify_authenticity_token

    def handle_payload
        # The following is a 'band-aid' to make testing and production work. The
        # requests from GitHub come in as a string, but requests from tests come
        # in as a ActionController::Parameters hash. So only call JSON.parse the
        # parameters if they are a string.
        @payload = params[:payload]
        @payload = JSON.parse(params[:payload]) if @payload.is_a?(String)
        @payload_body = request.body.read

        # Make sure that this hook came from a known repo
        repo = Repository.find_by(ghid: @payload['repository']['id'])
        return render(plain: 'Repository not found', status: :not_found) if repo.nil?
        WebhookHelper.verify_signature(repo.secret_key, @payload_body, request.env['HTTP_X_HUB_SIGNATURE'])

        case request.env['HTTP_X_GITHUB_EVENT']
        when 'pull_request'
            if @payload['action'] == 'opened'
                logger.debug 'WHC Received: pull_request[opened]'
                WebhookHelper.pr_opened(@payload)
            elsif @payload['action'] == 'synchronized'
                logger.debug 'WHC Received: pull_request[synchronized]'
                WebhookHelper.pr_synchronized(@payload)
            elsif @payload['action'] == 'closed'
                logger.debug 'WHC Received: pull_request[closed]'
                WebhookHelper.pr_closed(@payload)
            elsif @payload['action'] == 'reopened'
                logger.debug 'WHC Received: pull_request[reopened]'
                WebhookHelper.pr_reopened(@payload)
            else
                logger.debug 'WHC Received: pull_request[Unknown action]'
            end
        when 'issue_comment'
            logger.debug 'WHC Received: issue_comment'
            WebhookHelper.issue_comment(@payload)
        when 'ping'
            logger.debug 'WHC Received: ping'
            WebhookHelper.ping(@payload)
        # Send initial status message so Protected Branch can be setup
        else
            logger.debug 'WHC Received: Unknown Event'
            # Should this be an error? Got something we don't know how to handle
        end
        # For now don't send anything in body of message.
        # In future might add status message here
        render plain: "Received #{request.env['HTTP_X_GITHUB_EVENT']} Event"
    end
end
