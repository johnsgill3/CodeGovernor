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
        review.pr = _payload['number']
        review.repository = repo

        f_overrides = get_review_overrides(_payload['pull_request']['body'], repo)

        # Determine files to assign to reviewers
        no_reviewer = []
        f_user = Hash.new { |h, k| h[k] = [] }
        client.pull_request_files(repo.ghid, review.pr).each do |f|
            if f.status == 'added'
                # Create the new file and add it to the review
                file = GFile.new
                file.name = f.filename
                file.repository = repo
                file.user = User.find_by(ghuid: _payload['pull_request']['user']['id'])
                file.save!
                review.g_files << file

                # Set the reviewer
                if f_overrides.key?(f.filename)
                    f_user[f_overrides[f.filename]] << file
                else
                    # Missing: Post a comment to the PR indicating which files need to be assigned
                    no_reviewer << file
                end
            elsif f.status == 'modified' || f.status == 'deleted'
                file = GFile.find_by(repository: repo, name: f.filename)
                review.g_files << file

                # Set the reviewer
                if f_overrides.key?(f.filename)
                    f_user[f_overrides[f.filename]] << file
                elsif file.user.nickname == _payload['pull_request']['user']['login']
                    # Can't review your own code: Post a comment to the PR indicating file needs to be assigned
                    no_reviewer << file
                else
                    f_user[file.user] << file
                end
            else # TODO: Other file statuses - renamed?
                Rails.logger.error "Unknown file status #{f.status}"
            end
        end
        review.save! # Finalized everything for the review object. Commit it to repo.

        if no_reviewer.length > 0
            client.add_comment(repo.ghid, review.pr, "@#{_payload['pull_request']['user']['login']}\nThe following files need a reviewer assigned.\n"+
                                                      "Use the CG_REVIEWER_OVERRIDE tag to specify reviewers.\n- #{no_reviewer.map(&:name).join("\n- ")}")
        end

        # Add the feedback objects to the review
        f_user.each do |user, files|
            # Create feedback to track this users responses
            feedback = Feedback.new
            feedback.user = user
            feedback.review = review
            feedback.state = :pending
            feedback.save!

            # Add a comment to PR letting user know the files they have to review
            client.add_comment(repo.ghid, review.pr, "@#{user.nickname} files to review:\n- #{files.map(&:name).join("\n- ")}")
        end

        client.create_status(repo.ghid, _payload['pull_request']['head']['sha'], 'pending',
                             context: 'continuous-integration/codegovernor', description: 'Review Initiated')
    rescue Exception => e
        # TODO: - Handle DB errors
        # => ActiveRecord::RecordNotSaved
        # => ActiveRecord::StatementInvalid
        # => Other?
        Rails.logger.error e.message
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

    private

    def self.get_review_overrides(text, repo)
        # Following RegEx matches the override list from the text body
        override_re = Regexp.new('^CG_REVIEWER_OVERRIDE\r?\n((?:[-*]\s+[\w\/.]+\s*=\s*@?\w+\r?\n?)+)', Regexp::MULTILINE)

        r_assigns = override_re.match(text)
        # Get out the files and users to return
        file_users = {}
        if r_assigns
            r_assigns[1].split(/\r?\n/).each do |n|
                file, nickname = n.gsub(/[-\s*@]+/, '').split('=')
                user = User.find_by(nickname: nickname)
                unless user
                    user = User.from_github(nickname)
                    # TODO: Handle if GitHub cannot find nickname
                    user.repositories << repo
                    user.save!
                end
                file_users[file] = user
            end
        end
        file_users
    end
end
