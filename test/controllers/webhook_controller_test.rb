require 'test_helper'

class WebhookControllerTest < ActionController::TestCase
    test 'webhook events' do
        # Test all the basic events
        [:issue_comment, :ping, :unknown].each do |e|
            send_payload(e)
        end
    end

    test 'pull request actions' do
        # Test the various pull_request actions
        [:opened, :synchronized, :closed, :reopened, :unknown].each do |a|
            # As more functionality is written add to this param block
            t_payload = {action: a}
            send_payload(:pull_request, t_payload)
        end
    end

    private
    def send_payload(e_type, event_payload={})
        # Set the event type
        @request.headers['HTTP_X_GITHUB_EVENT'] = e_type.to_s

        # Generate the payload body and the sha1 signature
        payload_body = {payload: event_payload}
        gen_signature(payload_body)

        # Send the actual message
        post(:handle_payload, payload_body)

        # Check the response to make sure got okay
        assert_response(:success, "#{e_type} didn't receive 200 status")
        # Check that the body message matches
        assert_equal(@response.body, "Received #{e_type} Event")
    end

    def gen_signature(payload_body)
        signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'),
                                                      ENV['WEBHOOK_SECRET_KEY'],
                                                      payload_body.to_query)
        @request.headers['HTTP_X_HUB_SIGNATURE'] = signature
    end
end
