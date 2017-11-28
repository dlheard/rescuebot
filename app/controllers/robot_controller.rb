require 'net/http'
require "uri"
require "json"
require 'time'


class RobotController < ApplicationController
	skip_before_action :verify_authenticity_token
 	before_action :require_login

 	@@angle = 0

    def index
            @comment = Comment.new
            @comments = Comment.where('id > ?', params[:after_id].to_i).order('created_at DESC')
            @all_users = User.all
            render 'index.js.erb'
    end

 	def check_all_robots
 		@robot = Robot.new
 		@robots = Robot.all

 		#request should return json indicating
 		#whether robot is available or not
 		# {"available": false} or {"available": true}
 		@robots.each do |robot_link|
 			url = URI.parse(robot_link.robot_url)
 			http = Net::HTTP.new(url.host, url.port)
			request  = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
			response = http.request(request)
        	response_json = JSON.parse(response.body)

        	if response_json["available"] == true
        		Robot.update(robot_link.id, {"robot_url" => 1})
        	end
        end


 	end


 	def new
 		#check_all_robots()
 		# return first available robot
 		#@available_robots = Robot.find_by available: 1

 		#@robot_url = @available_robots.robot_url
 		#@robot_id = @available_robots.robot_id
 		#endpoint = "http://35.3.110.240/api/v1/setup/camera"
 		#url = URI.parse(endpoint)
 		#http = Net::HTTP.new(url.host,url.port)
 		#request = Net::HTTP::Post.new(url.path,'Content-Type' => 'application/json')
 		#response = http.request(request)
 		@comments = Comment.all
		@all_users = User.all

 	end

 	def control_camera
 		#endpoint = "http://35.3.110.240/api/v1/camera"
 		#url = URI.parse(endpoint)
 		#http = Net::HTTP.new(url.host,url.port)
 		#request  = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
 		msg = 0
 		if(params[:key] == "left")
 			if(@@angle != 0)
 				@@angle = @@angle - 30
 				msg = @@angle
 			else msg = 0
 			end
 		elsif (params[:key] == "right")
 			if(@@angle != 180)
 				@@angle = @@angle + 30
 				msg = @@angle
 			else msg = 180
 			end
 		end
 		#send_req = {:key => msg}
 		#request.body = send_req.to_json
 		#response = http.request(request)
 		#response_json = JSON.parse(response.body)
 	end



 	def control_motor
 		#binding.pry
 		#endpoint = "http://35.3.110.240/api/v1/motors"
 		#url = URI.parse(endpoint)
 		#http = Net::HTTP.new(url.host,url.port)
 		#request  = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
 		msg = "unknown"
 		if(params[:key] == "left")
 			msg = "left"
 		elsif (params[:key] == "right")
 			msg = "right"
 		elsif(params[:key] == "up")
 			msg = "up"
 		elsif(params[:key] == "down")
 			msg = "down"
 		end
 		send_req = {:key => msg}
 		#request.body = send_req.to_json
 		#response = http.request(request)
 		#response_json = JSON.parse(response.body)


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
        url = URI.parse("35.0.22.71/api/v1/gps")
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
