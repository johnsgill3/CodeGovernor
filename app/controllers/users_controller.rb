class UsersController < ApplicationController
    def index; end

    def show
        @user = User.find_by(id: params[:id])
    end

    def new; end

    def edit; end

    def create; end

    def update; end

    def destroy; end
end
