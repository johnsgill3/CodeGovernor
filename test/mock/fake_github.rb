require 'sinatra/base'
require 'json'

class FakeGitHub < Sinatra::Base
    configure do
        set :environment, :test

        # The following appends all the sinata output to the test log
        Logger.class_eval { alias_method :write, :<< }
        file = File.new(File.dirname(__FILE__) + "/../../log/#{settings.environment}.log", 'a+')
        file.sync = true
        $logger = Logger.new(file)
        use Rack::CommonLogger, $logger
        set :logging, nil
    end

    before do
        env['rack.logger'] = $logger
    end

    ###########################################################################
    # Begin GET requests
    get '/' do
        'You Found the GitHub API'
    end

    get '/user/repos' do
        logger.debug request
        logger.debug params.inspect
        logger.info

        user = request.env['HTTP_AUTHORIZATION'].split(' ')
        json_response 200, "#{user[1]}_repos_all.json"
    end

    get '/repos/:owner/:repo/branches/:branch' do
        logger.debug request
        logger.debug params.inspect

        json_response 200, "#{params[:owner]}_#{params[:repo]}_#{params[:branch]}.json"
    end

    get '/repositories/:repo/branches/:branch' do
        logger.debug request
        logger.debug params.inspect

        json_response 200, "#{params[:repo]}_#{params[:branch]}.json"
    end

    get '/repositories/:repo/git/trees/:sha1' do
        logger.debug request
        logger.debug params.inspect

        json_response 200, "#{params[:repo]}_#{params[:sha1]}_tree.json"
    end

    get '/repositories/:repo/pulls/:pull/files' do
        logger.debug request
        logger.debug params.inspect

        json_response 200, "#{params[:repo]}_pr_#{params[:pull]}_files.json"
    end

    ###########################################################################
    # Begin POST requests
    post '/repositories/:repo/issues/:pr/comments' do
        logger.debug request
        logger.debug params.inspect
        # params[:repo] params[:pr]
        # No need to send return content
        # Automatically returns success(200)
    end

    post '/repositories/:repo/statuses/:sha' do
        logger.debug request
        logger.debug params.inspect
        # params[:repo] params[:sha]
        # No need to send return content
        # Automatically returns success(200)
    end

    private

    def json_response(response_code, file_name)
        content_type :json
        status response_code
        File.open(File.dirname(__FILE__) + '/data/' + file_name, 'rb').read
    end
end
