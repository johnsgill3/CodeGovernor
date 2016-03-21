ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'webmock/minitest'
require File.expand_path('mock/fake_github', File.dirname(__FILE__))

class ActiveSupport::TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Make sure that WebMock is setup for each test
    setup do
        # Make sure that no connections outside of localhost are allowed
        WebMock.disable_net_connect!(allow_localhost: true)
        # Direct all api.github.com test requests to the FakeGithub
        WebMock.stub_request(:any, /api.github.com/).to_rack(FakeGitHub)
    end
end
