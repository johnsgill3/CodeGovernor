require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
    test 'has users' do
        Repository.all.each do |repo|
            assert_not_empty(repo.users, "Could not find any users for repo #{repo.id} - #{repo.ghid}")
        end
    end

    test 'has files' do
        Repository.all.each do |repo|
            assert_not_empty(repo.g_files, "Could not find any files for repo #{repo.id} - #{repo.ghid}")
        end
    end

    test 'has reviews' do
        Repository.all.each do |repo|
            assert_not_empty(repo.reviews, "Could not find any reviews for repo #{repo.id} - #{repo.ghid}")
        end
    end

    test 'enabled not null' do
        Repository.all.each do |repo|
            assert_not_nil(repo.enabled, "Repo #{repo.id} - #{repo.ghid} has null enabled")
        end
    end

    test 'secret_key not null' do
        Repository.all.each do |repo|
            assert_not_nil(repo.secret_key, "Repo #{repo.id} - #{repo.ghid} has null secret_key")
        end
    end

    test 'valid' do
        Repository.all.each do |repo|
            assert(repo.valid?, "Invalid repository #{repo.id}" + repo.errors.messages.to_json)
        end
    end

    # Write tests for CRUD actions
    test 'create' do
        # Generate a few random users
        prng = Random.new
        users = (2..prng.rand(3..5)).map { |_| users("user_#{prng.rand(100)}".to_sym) }

        # Test create via parameters
        repoP = Repository.new(ghid: 990,
                               enabled: true,
                               secret_key: SecureRandom.hex(20),
                               users: users)
        assert_not_nil(repoP, 'Could not create repository via parameters')
        assert(repoP.valid?, "Invalid repository #{repoP.ghid}\n" + repoP.errors.messages.to_json)
        assert(repoP.save!, "Could not save repository #{repoP.ghid}")

        # Test create via attributes
        repoA = Repository.new
        repoA.ghid = 991
        repoA.enabled = true
        repoA.secret_key = SecureRandom.hex(20)
        repoA.users = users
        assert_not_nil(repoA, 'Could not create repository via attributes')
        assert(repoA.valid?, "Invalid repository #{repoA.ghid}" + repoA.errors.messages.to_json)
        assert(repoA.save!, "Could not save repository #{repoA.ghid}")

        # Test create via hash
        repoH_param = {
            ghid: 992,
            enabled: true,
            secret_key: SecureRandom.hex(20),
            users: users }
        repoH = Repository.new(repoH_param)
        assert_not_nil(repoH, 'Could not create repository via hash')
        assert(repoH.valid?, "Invalid repository #{repoH.ghid}" + repoH.errors.messages.to_json)
        assert(repoH.save!, "Could not save repository #{repoH.ghid}")

        # Test create via block
        repoB = Repository.new do |r|
            r.ghid = 993
            r.enabled = true
            r.secret_key = SecureRandom.hex(20)
            r.users = users
        end
        assert_not_nil(repoB, 'Could not create repository via hash')
        assert(repoB.valid?, "Invalid repository #{repoB.ghid}" + repoB.errors.messages.to_json)
        assert(repoB.save!, "Could not save repository #{repoB.ghid}")
    end

    test 'update' do
        # Test Single Repository update via attribute
        repo = repositories(:repo_0)
        assert_not_nil(repo, 'Could not find repo repo_0')
        repo.enabled = !repo.enabled
        assert(repo.valid?, "Invalid repository #{repo.id} - #{repo.ghid}" + repo.errors.messages.to_json)
        assert(repo.save!, "Could not save repository #{repo.id} - #{repo.ghid}")

        # Test Update All Repositories
        assert_equal(10, Repository.update_all('enabled = true'), 'Update did not update correct number of rows')

        # Test Update via hash
        repositories(:repo_1).update(enabled: false)
    end

    test 'read' do
        Repository.all.each do |r|
            repo = Repository.find_by(ghid: r.ghid)
            assert_not_nil(repo, "Could not find repo with GitHubID = #{r.ghid}")
        end
    end

    test 'delete' do
        repo = repositories(:repo_0)
        assert_not_nil(repo, 'Could not find repo repo_0')
        assert(repo.destroy, 'Could not destroy repo repo_0')
    end

    test 'enable repository' do
        repoA = Repository.new
        repoA.ghid = 53_015_817
        repoA.users = [users(:user_0), users(:user_1)]
        repoA.save!
        repoA.enable_repository(users(:user_1))
    end
end
