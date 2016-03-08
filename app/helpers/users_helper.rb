module UsersHelper
    def get_repos(user)
        client = Octokit::Client.new :access_token => user.token

        @repos = Hash.new {|h,k| h[k] = Array.new }
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
