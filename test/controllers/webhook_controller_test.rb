require 'test_helper'

=begin
Response types:
    :success - 200-299
    :redirect - 300-399
    :missing - 404
    :error - 500-599
=end

class WebhookControllerTest < ActionController::TestCase
    def setup
        prng = Random.new
        @repo = repositories("repo_#{prng.rand(10)}".to_sym)
        @t_payload = {repository: { id: @repo.ghid }}
    end

    test 'event kinds' do
        # Test all the basic events
        [:issue_comment, :ping, :unknown].each do |e|
            send_payload(e)
        end
    end

    test 'pull request actions' do
        # Test the various pull_request actions
        [:opened, :synchronized, :closed, :reopened, :unknown].each do |a|
            # As more functionality is written add to this param block
            @t_payload[:action] = a
            send_payload(:pull_request)
        end
    end

    test 'unknown repository' do
        @t_payload[:repository][:id] = 990
        send_payload(:ping, :missing)
    end

    private
    def send_payload(e_type, r_type=:success)
        # Set the event type
        @request.headers['HTTP_X_GITHUB_EVENT'] = e_type.to_s

        # Generate the payload body and the sha1 signature
        payload_body = {payload: @t_payload}
        gen_signature(payload_body)

        # Send the actual message
        post(:handle_payload, payload_body)


        assert_response(r_type, "#{e_type} didn't receive correct status")
        
        if r_type == :success
            assert_equal(@response.body, "Received #{e_type} Event")
        end
    end

    def gen_signature(payload_body)
        signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'),
                                                      @repo.secret_key,
                                                      payload_body.to_query)
        @request.headers['HTTP_X_HUB_SIGNATURE'] = signature
    end
end
