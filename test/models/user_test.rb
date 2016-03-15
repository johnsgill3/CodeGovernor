require 'test_helper'

class UserTest < ActiveSupport::TestCase
    test 'has repository' do
        100.times do |u|
            user = User.find_by(ghuid: u)
            assert_not_nil(user, "Could not find user #{u}")
            assert_not_empty(user.repositories, "Could not find any repositories for user #{user.ghuid}")
        end
    end

    test 'has files' do
        100.times do |u|
            user = User.find_by(ghuid: u)
            assert_not_nil(user, "Could not find user #{u}")
            assert_not_empty(user.g_files, "Could not find any files for user #{user.ghuid}")
        end
    end

    test 'has feedback' do
        100.times do |u|
            user = User.find_by(ghuid: u)
            assert_not_nil(user, "Could not find user #{u}")
            assert_not_empty(user.feedbacks, "Could not find any feedback for user #{user.ghuid}")
        end
    end

    test 'has nickname' do
        100.times do |u|
            user = User.find_by(ghuid: u)
            assert_not_nil(user, "Could not find user #{u}")
            assert_not_nil(user.nickname, "User #{user.ghuid} has null nickname")
        end
    end

    # In production token is not required - but just make sure in test it's there
    test 'has token' do
        100.times do |u|
            user = User.find_by(ghuid: u)
            assert_not_nil(user, "Could not find user #{u}")
            assert_not_nil(user.token, "User #{user.ghuid} has null token")
        end
    end
end
