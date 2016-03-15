require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
    test 'has users' do
        10.times do |r|
            repo = Repository.find_by(ghid: r)
            assert_not_nil(repo, "Could not find repo #{r}")
            assert_not_empty(repo.users, "Could not find any users for repo #{repo.ghid}")
        end
    end

    test 'has files' do
        10.times do |r|
            repo = Repository.find_by(ghid: r)
            assert_not_nil(repo, "Could not find repo #{r}")
            assert_not_empty(repo.g_files, "Could not find any files for repo #{repo.ghid}")
        end
    end

    test 'has reviews' do
        10.times do |r|
            repo = Repository.find_by(ghid: r)
            assert_not_nil(repo, "Could not find repo #{r}")
            assert_not_empty(repo.reviews, "Could not find any reviews for repo #{repo.ghid}")
        end
    end

    test 'enabled not null' do
        10.times do |r|
            repo = Repository.find_by(ghid: r)
            assert_not_nil(repo, "Could not find repo #{r}")
            assert_not_nil(repo.enabled, "Repo #{repo.ghid} has null enabled")
        end
    end

    test 'secret_key not null' do
        10.times do |r|
            repo = Repository.find_by(ghid: r)
            assert_not_nil(repo, "Could not find repo #{r}")
            assert_not_nil(repo.secret_key, "Repo #{repo.ghid} has null secret_key")
        end
    end
end
