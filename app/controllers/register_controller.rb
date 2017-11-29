class RegisterController < ApplicationController
	skip_before_action :verify_authenticity_token 
	before_action :require_login #, :raise => false
	skip_before_action :require_login, only: [:register,:create_user]

	def register 

    end

    def create_user  
    flash[:error] = nil
    flash[:notice] = nil
    
        if User.exists?(:email => params[:email])
            flash[:error] = "A user with this email already exists"
            render :action => :new
        else
            avatar_url = "https://i.pinimg.com/736x/5d/a0/8d/5da08d24bc4c7d2847ee5dfa1604b114--naruto-shippudden-naruto-pics.jpg"
         
            @user = User.new({:username => params[:name], :avatar_url => avatar_url, :email => params[:email],:password => params[:password],
                :password_confirmation => params[:confirm]})
            @user.save  

            flash[:notice] = "User sucessfully created"  

            session[:current_user] = @user.id  
            session[:signed_in] = true
            session[:username] = params[:name]
            session[:avatar_url] = @user.avatar_url
            session[:control_robot] = "false"
            session[:robot_url] = ""
            redirect_to root_path

            # later on check response[error]? if its there flash a message
        end      

    end  

end
