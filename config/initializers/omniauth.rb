# Use the OmniAuth Middleware for GitHub authentication
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :github, ENV['GH_CLIENT_ID'], ENV['GH_CLIENT_SECRET'], scope: "user,repo,admin:repo_hook"
end
