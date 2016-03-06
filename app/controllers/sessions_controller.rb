class SessionsController < ApplicationController
  def create
    render text: request.env['omniauth.auth'].to_json
  end
end
