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
                session[:control_robot] = "false"
                session[:robot_url] = ""
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
        if(session[:control_robot] == "true")
            robot_url = session[:robot_url]
            link = "#{robot_url}/api/v1/robot/enable" #enable availability of robot
            url = URI.parse(link)
            http = Net::HTTP.new(url.host, url.port)
            request  = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
            response = http.request(request) 
            response_json = JSON.parse(response.body) 
            session[:robot_url] = ""
            session[:control_robot] = "false"
        end
        redirect_to root_path
    end


end
