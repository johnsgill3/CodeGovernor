require 'sinatra/base'
require 'json'

class FakeGitHub < Sinatra::Base
    configure do
        set :environment, :test

        # The following appends all the sinata output to the test log
        Logger.class_eval { alias :write :'<<' }
        file = File.new(File.dirname(__FILE__)+"/../../log/#{settings.environment}.log", 'a+')
        file.sync = true
        $logger = Logger.new(file)
        use Rack::CommonLogger, $logger
        set :logging, nil
    end

    before do
    	env['rack.logger'] = $logger
    end

    # Handle various requests
    get '/' do
        'You Found the GitHub API'
    end

    get '/repos/:owner/:repo/branches/:branch' do
        logger.debug request
        logger.debug params.inspect

        owner = params[:captures][0]
        repo = params[:captures][1]
        branch = params[:captures][2]
        json_response 200, "#{owner}_#{repo}_#{branch}.json"
    end

    get '/repositories/:repo/branches/:branch' do
        logger.debug request
        logger.debug params

        repo = params[:captures][0]
        branch = params[:captures][1]
        json_response 200, "#{repo}_#{branch}.json"
    end

    private
    def json_response(response_code, file_name)
        content_type :json
        status response_code
        File.open(File.dirname(__FILE__) + '/data/' + file_name, 'rb').read
    end
end
