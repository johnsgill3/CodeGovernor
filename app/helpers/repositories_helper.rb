module RepositoriesHelper
    class << self
        def add_repository(ghid, _user)
            repo = Repository.new
            repo.ghid = ghid
            # Just add to our DB for tracking. Don't enable yet
            # Call enable_repository to add files and begin governing
            repo.enabled = false
            repo.secret_key = SecureRandom.hex(20)
            repo.users = [_user] # Set initial user to current user
            repo.save!
        rescue Exception => e
            # TODO: - Handle DB errors
            # => ActiveRecord::RecordNotSaved
            # => ActiveRecord::StatementInvalid
            # => Other?
            Rails.logger.error e.message
        end
    end
end
