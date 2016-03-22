require 'test_helper'

class UserTest < ActiveSupport::TestCase
    test 'has repository' do
        User.all.each do |user|
            assert_not_empty(user.repositories, "Could not find any repositories for user #{user.id} - #{user.ghuid}")
        end
    end

    test 'has files' do
        User.all.each do |user|
            assert_not_empty(user.g_files, "Could not find any files for user #{user.id} - #{user.ghuid}")
        end
    end

    test 'has feedback' do
        User.all.each do |user|
            assert_not_empty(user.feedbacks, "Could not find any feedback for user #{user.id} - #{user.ghuid}")
        end
    end

    test 'has nickname' do
        User.all.each do |user|
            assert_not_nil(user.nickname, "User #{user.id} - #{user.ghuid} has null nickname")
        end
    end

    # In production token is not required - but just make sure in test it's there
    test 'has token' do
        User.all.each do |user|
            assert_not_nil(user.token, "User #{user.id} - #{user.ghuid} has null token")
        end
    end

    test 'valid' do
        User.all.each do |user|
            assert(user.valid?, "Invalid user #{user.id}"+user.errors.messages.to_json)
        end
    end

    # Write tests for CRUD actions
    test 'create' do
        # Generate random associations
        prng = Random.new
        token = SecureRandom.hex(15)
        repos = (1..prng.rand(1..5)).map {|_| repositories("repo_#{prng.rand(10)}".to_sym)}

        # Test create via parameters
        userP = User.new(ghuid: 990,
                         nickname: "ghuser990",
                         token: token,
                         repositories: repos)
        assert_not_nil(userP, "Could not create user via parameters")
        assert(userP.valid?, "Invalid user #{userP.id} - #{userP.ghuid}\n"+userP.errors.messages.to_json)
        assert(userP.save!, "Could not save user #{userP.id} - #{userP.ghuid}")

        # Test create via attributes
        userA = User.new
        userA.ghuid = 991
        userA.nickname = "ghuser991"
        userA.token = token
        userA.repositories = repos
        assert_not_nil(userA, "Could not create user via parameters")
        assert(userA.valid?, "Invalid user #{userA.id} - #{userA.ghuid}\n"+userA.errors.messages.to_json)
        assert(userA.save!, "Could not save user #{userA.id} - #{userA.ghuid}")

        # Test create via hash
        userHparam = {
            ghuid: 992,
            nickname: "ghuser992",
            token: token,
            repositories: repos}
        userH = User.new(userHparam)
        assert_not_nil(userH, "Could not create user via parameters")
        assert(userH.valid?, "Invalid user #{userH.id} - #{userH.ghuid}\n"+userH.errors.messages.to_json)
        assert(userH.save!, "Could not save user #{userH.id} - #{userH.ghuid}")

        # Test create via block
        userB = User.new do |u|
            u.ghuid = 993
            u.nickname = "ghuser993"
            u.token = token
            u.repositories = repos
        end
        assert_not_nil(userB, "Could not create user via parameters")
        assert(userB.valid?, "Invalid user #{userB.id} - #{userB.ghuid}\n"+userB.errors.messages.to_json)
        assert(userB.save!, "Could not save user #{userB.id} - #{userB.ghuid}")
    end

    test 'update' do
        # Test Single update via attribute
        user = users(:user_0)
        assert_not_nil(user, "Could not find user #{:user_0}")
        user.nickname = "ghuser990"
        assert(user.valid?, "Invalid user #{user.id} - #{user.ghuid}"+user.errors.messages.to_json)
        assert(user.save!, "Could not save user #{user.id} - #{user.ghuid}")

        # Test Update All
        assert_equal(100, User.update_all(nickname: "gh_user"), "Update did not update correct number of rows")

        # Test Update via hash
        users(:user_1).update(nickname: "ghuser991")
    end

    test 'read' do
        User.all.each do |u|
            user = User.find_by(ghuid: u.ghuid)
            assert_not_nil(user, "Could not find user with id = #{u.id}")
        end
    end

    test 'delete' do
        user = users(:user_0)
        assert_not_nil(user, "Could not find user #{:user_0}")
        # Need to reassign all the files for this user before can be dropped
        user.g_files.each { |f| f.update(user: users(:user_1)) }
        # Destroy the feedbacks for this user as they won't exist anymore
        user.feedbacks.each { |f| f.destroy }
        # Now can finally call destory on the user
        user.destroy
    end

    test 'from omniauth' do
        # TODO Once OmniAuth mock is available
    end

    test 'repos from github' do
        # TODO Once GitHub mock is available
    end
end
