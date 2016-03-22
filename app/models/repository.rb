class Repository < ActiveRecord::Base
    has_and_belongs_to_many :users
    has_many :g_files,
             dependent: :destroy,
             inverse_of: :repository
    has_many :reviews,
             dependent: :destroy,
             inverse_of: :repository

    validates :users, presence: true
    validates :ghid, uniqueness: true
    #     ghid:integer:index
    #     enabled:boolean
    #     secret_key:string

    def enable_repository(user)
        client = Octokit::Client.new client_id: ENV['GH_CLIENT_ID'], client_secret: ENV['GH_CLIENT_SECRET']

        begin
            # Get all the files for the master branch
            current_files = g_files.pluck(:name)
            # TODO: Should branch be a parameter? What happens if master branch doesn't exist?
            master_branch_sha = client.branch(ghid, 'master').commit.sha
            client.tree(ghid, master_branch_sha, recursive: true).tree.each do |gh_file|
                # Only add new files - this could be re-enable of a repository
                next if current_files.include?(gh_file.path)
                file = GFile.new
                file.name = gh_file.path
                file.repository = self
                file.user = user
                file.save!
            end
            update(enabled: true)
        rescue Octokit::NotFound => e
            # TODO: - Handle branch not found
            logger.error "OctoKit error #{e.message}"
        rescue Exception => e
            # TODO: - Handle DB errors
            # => ActiveRecord::RecordNotSaved
            # => ActiveRecord::StatementInvalid
            # => Other?
            logger.error "DB error #{e.message}"
        end
    end
end
