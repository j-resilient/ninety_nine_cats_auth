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
            # add error
            flash.now[:errors] = "Incorrect username or password."
            render :new
        else
            # set cookie, redirect to /cats
            token = user.reset_session_token!
            session[:session_token] = token
            redirect_to cats_url
        end
    end
end