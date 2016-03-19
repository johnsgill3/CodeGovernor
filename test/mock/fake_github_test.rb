require 'test_helper'

class SubRequestTest < ActiveSupport::TestCase
    test 'no external access' do
        uri = URI('https://www.google.com')
        assert_raises(WebMock::NetConnectNotAllowedError) { Net::HTTP.get(uri) }
    end

    test 'fake github api' do
        url = 'https://api.github.com/'
        uri = URI(url)

        response = Net::HTTP.get(uri)
        assert_requested(:get, url)
        assert_equal('You Found the GitHub API', response, 'Unexpected response')
    end

    test 'basic octokit using client' do
        client = Octokit::Client.new client_id: ENV['GH_CLIENT_ID'], client_secret: ENV['GH_CLIENT_SECRET']

        assert_equal('edd40f80e8e0a2eb19bcc56cf33d1f59e4d34fd8', client.branch(53_015_817, 'master').commit.sha, 'Mismatched content')
        assert_equal('edd40f80e8e0a2eb19bcc56cf33d1f59e4d34fd8', client.branch('CodeGovernor/CodeGovernor', 'master').commit.sha, 'Mismatched content')
    end

    test 'basic octokit using token' do
        client = Octokit::Client.new access_token: users(:user_0).token

        assert_equal('edd40f80e8e0a2eb19bcc56cf33d1f59e4d34fd8', client.branch(53_015_817, 'master').commit.sha, 'Mismatched content')
        assert_equal('edd40f80e8e0a2eb19bcc56cf33d1f59e4d34fd8', client.branch('CodeGovernor/CodeGovernor', 'master').commit.sha, 'Mismatched content')
    end
end
