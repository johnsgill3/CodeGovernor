class SessionsController < ApplicationController
    def create
        @user = User.from_omniauth(request.env['omniauth.auth'])
        session[:user_id] = @user.id
        redirect_to user_path(@user)
    rescue
        flash[:warning] = 'There was an error while trying to authenticate you...'
        redirect_to root_path
    end

    def destroy
        session.delete(:user_id) if current_user
        redirect_to root_path
    end
end
