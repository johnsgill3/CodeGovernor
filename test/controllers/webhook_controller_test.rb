require 'test_helper'

# Response types:
#     :success - 200-299
#     :redirect - 300-399
#     :missing - 404
#     :error - 500-599

class WebhookControllerTest < ActionController::TestCase
    #self.use_transactional_fixtures = false
    def setup
        @repo = repositories(:test_repo)
    end

    test 'event kinds' do
        # Test all the basic events
        [:issue_comment, :ping, :unknown].each do |e|
            if [:ping].include?(e)
                @t_payload = JSON.parse(File.open(File.dirname(__FILE__) + "/../mock/data/hook_#{e}.json").read)
            else
                @t_payload = { repository: { id: @repo.ghid } }
            end
            send_payload(e)
        end
    end

    test 'pull request actions' do
        # Test the various pull_request actions
        repositories(:test_repo).enable_repository(users(:tr_user_0))

        [:opened1, :opened2, :closed, :reopened, :unknown].each do |a|
            if [:opened1, :opened2, :closed, :reopened].include?(a)
                @t_payload = JSON.parse(File.open(File.dirname(__FILE__) + "/../mock/data/hook_pr_#{a}.json").read)
            else
                @t_payload = { repository: { id: @repo.ghid } }
                @t_payload[:action] = a
            end

            send_payload(:pull_request)
        end
    end

    test 'unknown repository' do
        @t_payload = { repository: { id: 990 } }
        send_payload(:ping, :missing)
    end

    private

    def send_payload(e_type, r_type = :success)
        # Set the event type
        @request.headers['HTTP_X_GITHUB_EVENT'] = e_type.to_s

        # Generate the payload body and the sha1 signature
        payload_body = { payload: @t_payload }
        gen_signature(payload_body)

        # Send the actual message
        post(:handle_payload, payload_body)

        assert_response(r_type, "#{e_type} #{e_type == :pull_request ? @t_payload[:action] : ''} didn't receive correct status")

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
