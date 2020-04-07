class SessionsController < ApplicationController
    def new
        render :new
    end

    def create
        user = User.find_by_credentials(
            params[:user][:username],
            params[:user][:password]
        )

        if user.nil?
            flash.now[:errors] = "Incorrect username or password."
            render :new
        else
            token = user.reset_session_token!
            session[:session_token] = token
            redirect_to cats_url
        end
    end

    def destroy
        current_user.reset_session_token! unless current_user.nil?
        session[:session_token] = nil
        redirect_to new_session_url
    end
end