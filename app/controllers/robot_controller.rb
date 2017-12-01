require 'net/http'
require "uri"
require "json"
require 'time'


class RobotController < ApplicationController
	skip_before_action :verify_authenticity_token
 	before_action :require_login

 	@@angle_1 = 0
    @@angle_2 = 0

    @@motor_speed = 180

    def index
            @comment = Comment.new
            @comments = Comment.where('id > ?', params[:after_id].to_i).order('created_at DESC')
            @all_users = User.all
            render 'index.js.erb'
    end

    def check_all_robots
        if(session[:control_robot] == "false")
            @robot = Robot.new
            @robots = Robot.all
            #request should return json indicating
            #whether robot is available or not
            # {"available": false} or {"available": true}
           robot_control = 0
            @robots.each do |robot_link|
                link = "#{robot_link.robot_url}/api/v1/robot/available"
                url = URI.parse(link)
                http = Net::HTTP.new(url.host, url.port)
                request  = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
                response = http.request(request)
                response_json = JSON.parse(response.body)

                if response_json["available"] == 1
                    link = "#{robot_link.robot_url}/api/v1/robot/dissable" #dissable availability of robot
                    url = URI.parse(link)
                    http = Net::HTTP.new(url.host, url.port)
                    request  = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
                    response = http.request(request)
                    response_json = JSON.parse(response.body)
                    session[:control_robot] = "true"
                    session[:robot_url] = robot_link.robot_url
                    robot_control = 1
                    return
               end
            end
            if(robot_control == 0)
                rand_num = (rand() * 100).to_i
                mod_2 = rand_num % 2
                if(mod_2 == 0)
                    session[:robot_url] = "http://35.3.22.126"
                else session[:robot_url] = "http://35.3.105.240"
                end
            end
        end
    end


 	def new
        check_all_robots() #returns link of first available robot in database
        if(session[:control_robot] == "true")
            flash[:notice_1] = "Congrats!"
            flash[:notice_2] = "There is a robot available for you to control."
        else
            flash[:notice_1] = "Sorry!"
            flash[:notice_2] = "There are no robots available but you can spectate."
        end
        if(session[:robot_url] != "")
            robot_url = session[:robot_url]
            @video_url = "#{robot_url}:9000/?action=stream"
        end

        if(session[:control_robot] == "true")
            robot_url = session[:robot_url]
            endpoint = "#{robot_url}/api/v1/setup/camera"
            url = URI.parse(endpoint)
            http = Net::HTTP.new(url.host,url.port)
            request = Net::HTTP::Post.new(url.path,'Content-Type' => 'application/json')
            response = http.request(request)
        end
 		@comments = Comment.all
		@all_users = User.all

 	end

 	def control_camera_1
        if(session[:control_robot] == "true")
             robot_url = session[:robot_url]
             endpoint =  "#{robot_url}/api/v1/camera/1"
             url = URI.parse(endpoint)
             http = Net::HTTP.new(url.host,url.port)
             request  = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
             msg = 0
             if(params[:key] == "left")
                if(@@angle_1 != 0)
                   @@angle_1 = @@angle_1 - 30
                   msg = @@angle_1
                else msg = 0
                end
             elsif (params[:key] == "right")
                if(@@angle_1 != 180)
                   @@angle_1 = @@angle_1 + 30
                   msg = @@angle_1
                else msg = 180
                end
             end
             send_req = {:key => msg}
             request.body = send_req.to_json
             response = http.request(request)
             response_json = JSON.parse(response.body)
        end
 	end

    def control_camera_2
        if(session[:control_robot] == "true")
             robot_url = session[:robot_url]
             endpoint =  "#{robot_url}/api/v1/camera/2"
             url = URI.parse(endpoint)
             http = Net::HTTP.new(url.host,url.port)
             request  = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
             msg = 0
             if(params[:key] == "down")
                if(@@angle_2 != 0)
                   @@angle_2 = @@angle_2 - 30
                   msg = @@angle_2
                else msg = 0
                end
             elsif (params[:key] == "up")
                if(@@angle_2 != 180)
                   @@angle_2 = @@angle_2 + 30
                   msg = @@angle_2
                else msg = 180
                end
             end
             send_req = {:key => msg}
             request.body = send_req.to_json
             response = http.request(request)
             response_json = JSON.parse(response.body)
        end
    end

    def motor_speed
        if(session[:control_robot] == "true")
             robot_url = session[:robot_url]
             endpoint =  "#{robot_url}/api/v1/motors/speed"
             url = URI.parse(endpoint)
             http = Net::HTTP.new(url.host,url.port)
             request  = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
             msg = 0
             if(params[:speed] == "down")
                if(@@motor_speed != 0)
                   @@motor_speed = @@motor_speed - 30
                   msg = @@motor_speed
                else msg = 0
                end
             elsif (params[:speed] == "up")
                if(@@motor_speed != 180)
                   @@motor_speed = @@motor_speed + 30
                   msg = @@motor_speed
                else msg = 180
                end
             end
             send_req = {:speed => msg}
             request.body = send_req.to_json
             response = http.request(request)
             response_json = JSON.parse(response.body)
        end
    end



 	def control_motor
 		#binding.pry
 	    if(session[:control_robot] == "true")
             robot_url = session[:robot_url]
             endpoint = "#{robot_url}/api/v1/motors"
             url = URI.parse(endpoint)
             http = Net::HTTP.new(url.host,url.port)
             request  = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
             msg = "unknown"
             if(params[:key] == "left")
                msg = "left"
             elsif (params[:key] == "right")
                msg = "right"
             elsif(params[:key] == "up")
                msg = "up"
             elsif(params[:key] == "down")
                msg = "down"
             elsif(params[:key] == "stop")
                msg = "stop"
             end
             send_req = {:key => msg}
             request.body = send_req.to_json
             response = http.request(request)
             response_json = JSON.parse(response.body)
        end


 	end



 	def comment

        respond_to do |format|

 		    curr_user_id = session[:current_user]
    	    curr_username = session[:username]
            time_json = get_datetime()
            time = time_json["time_posted"]
 		   @comment = Comment.new({:user_id => curr_user_id, :username => curr_username,
    		  :content => params[:text], :time => time})
    	   @comment.save

            format.html {redirect_to robot_path}
            format.js {render 'comment.js.erb'}
        end

 	end

    def gps
        if(session[:robot_url] != "")
            robot_url = session[:robot_url]
            endpoint = "#{robot_url}/api/v1/gps"
            url = URI.parse(endpoint)
            http = Net::HTTP.new(url.host,url.port)
            request  = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
            response = http.request(request)
            gps_data = response.body
            if(gps_data["GPS_DATA"] == " " or gps_data["GPS_DATA"] == "")
                gps_data["GPS_DATA"] = "0 0"
            end
            render :json => gps_data
        end

    end







end
