class User < ActiveRecord::Base
    has_and_belongs_to_many :repositories
    has_many :g_files, inverse_of: :user
    has_many :feedbacks, inverse_of: :user

    validates :ghuid, uniqueness: true
    #     ghuid:integer:index
    #     nickname:string
    #     token:string

    def self.from_github(nickname)
        client = Octokit::Client.new client_id: ENV['GH_CLIENT_ID'], client_secret: ENV['GH_CLIENT_SECRET']

        gh_user = client.user(nickname)
        user = User.new
        user.ghuid = gh_user[:id]
        user.nickname = gh_user[:login]
        user.save!
        user
    end

    def self.from_omniauth(auth_hash)
        user = find_or_create_by(ghuid: auth_hash['uid'])
        user.nickname = auth_hash['info']['nickname']
        user.token = auth_hash['credentials']['token']
        user.save!
        user
    end

    def get_repos_from_github
        client = Octokit::Client.new access_token: token

        @repos = Hash.new { |h, k| h[k] = [] }
        client.repositories.each do |repository|
            full_name = repository[:full_name]

            if repository[:permissions][:admin]
                @repos[:admin].push full_name
            elsif
                @repos[:push].push full_name
            else
                @repos[:pull].push full_name
            end
        end
        @repos
    end
end
