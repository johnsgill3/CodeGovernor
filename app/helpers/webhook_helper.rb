module WebhookHelper
    def self.verify_signature(key, payload_body, gh_signature)
        signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), key, payload_body)
        Rack::Utils.secure_compare(signature, gh_signature)
    end

    def self.pr_opened(_payload)
        client = Octokit::Client.new client_id: ENV['GH_CLIENT_ID'], client_secret: ENV['GH_CLIENT_SECRET']
        repo = Repository.find_by(ghid: _payload['repository']['id'])

        # Start a new Review
        review = Review.new
        review.state = :pending
        review.pr = _payload[:number]
        review.repository = repo

        # Determine files to assign to reviewers
        #new_files = []
        f_user = Hash.new { |h, k| h[k] = [] }
        client.pull_request_files(repo.ghid, review.pr).each do |f|
            if f.status == 'added'
                # TODO: How to determine reviewers for new files?
                # new_files << f.filename
                file = GFile.new
                file.name = f.filename
                file.repository = repo
                file.user = User.find_by(ghuid: _payload[:sender][:id])
                file.save!
                review.g_files << file
                f_user[file.user] << file
            elsif f.status == 'modified'
                file = GFile.find_by(repository: repo, name: f.filename)
                review.g_files << file
                f_user[file.user] << file
            elsif f.status == 'deleted'
                # TODO: Should removed files still be reviewed?
            else # TODO: Other file statuses - renamed?
                Rails.logger.error "Unknown file status #{f.status}"
            end
        end

        f_user.each do |user, files|
            # Create feedback to track this users responses
            # TODO: Create one feedback per file?
            feedback = Feedback.new
            feedback.user = user
            feedback.review = review
            feedback.state = :pending
            feedback.save!

            # Add a comment to PR letting user know the files they have to review
            Rails.logger.error "@#{user.nickname} Files to review:\n- #{files.map(&:name).join("\n- ")}"
            client.add_comment(repo.ghid, review.pr, "@#{user.nickname} Files to review:\n- #{files.map(&:name).join("\n- ")}")
        end
        review.save! # Finalized everything for the review. Commit it to repo

        client.create_status(repo.ghid, _payload[:pull_request][:head][:sha], 'pending',
                             context: 'continuous-integration/codegovernor', description: 'Review Initiated')
        # rescue Exception => e
        #     # TODO: - Handle DB errors
        #     # => ActiveRecord::RecordNotSaved
        #     # => ActiveRecord::StatementInvalid
        #     # => Other?
        #     Rails.logger.error e.message
    end

    def self.pr_synchronized(_payload)
    end

    def self.pr_closed(_payload)
    end

    def self.pr_reopened(_payload)
    end

    def self.issue_comment(_payload)
    end

    def self.ping(_payload)
    end
end
