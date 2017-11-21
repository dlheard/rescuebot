class LoginController < ApplicationController


skip_before_action :verify_authenticity_token 
before_action :require_login #, :raise => false
skip_before_action :require_login, only: [:login,:login_create]



	def login 

    end

    def login_create 
        flash[:notice] = nil
        @pot_user = User.find_by email: params[:email]
        if @pot_user != nil
            @verify_user = @pot_user.authenticate(params[:password])        
            if @verify_user != nil 
                session[:current_user] = @verify_user.id
                session[:username] = @verify_user.username
                session[:signed_in] = true
                session[:avatar_url] = @verify_user.avatar_url
                redirect_to root_path
            else 
                flash[:notice] = "incorrect password try again"
            end
        else 
            flash[:notice] = "incorrect email try again"

        end   

    end 


    def logout 
        session[:signed_in] = false
        redirect_to root_path
    end


end
