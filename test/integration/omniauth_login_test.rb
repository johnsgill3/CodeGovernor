require 'test_helper'

class OmniAuthLoginTest < ActionDispatch::IntegrationTest
    def setup
        OmniAuth.config.test_mode = true
        mock_auth_hash
    end

    def teardown
        OmniAuth.config.mock_auth[:github] = nil
    end

    test 'login' do
        get '/'
        assert_response :success
        assert_template 'welcome/index'
        assert_select 'a', {text: 'GitHub'}

        # Follow all redirects which should get to user page with repo listing
        get_via_redirect '/auth/github', {}, { 'omniauth.auth' => OmniAuth.config.mock_auth[:github] }
        assert_response :success
        assert_template 'users/show'
    end

    private

    def mock_auth_hash
        omniauth_hash = { 'provider' => 'github',
                          'uid' => '12345',
                          'info' => {
                              'name' => 'natasha',
                              'email' => 'hi@natashatherobot.com',
                              'nickname' => 'NatashaTheRobot'
                          },
                          'credentials' => {
                              'token' => 12345
                          }
        }

        OmniAuth.config.add_mock(:github, omniauth_hash)
    end
end
