class SessionsController < ApplicationController
    def new
        if session[:session_token].nil?
            render :new
        else
            flash.now[:errors] = "You are already logged in!"
            redirect_to cats_url
        end
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
            user.reset_session_token!
            login_user!(user)
            redirect_to cats_url
        end
    end

    def destroy
        current_user.reset_session_token! unless current_user.nil?
        session[:session_token] = nil
        redirect_to new_session_url
    end
end