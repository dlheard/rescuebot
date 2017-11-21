class AddRobotController < ApplicationController
skip_before_action :verify_authenticity_token   
 	before_action :require_login


 	def add

 	end

 	
 	def add_post 


 		if (params[:lat] != nil) and (params[:lon] != nil)
 			@robot = Robot.new({:robot_url => params[:url], :lon => params[:lon], :lat => params[:lat]}) 
 			@robot.save 
 		else 
			@robot = Robot.new({:robot_url => params[:url]})
			@robot.save	
 		end

 	end 


end
