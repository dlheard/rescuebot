require 'net/http'
require "uri" 
require "json"
require 'time'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
    # handle exception for invalid user logins (TODO)
    def require_login  
        if  session[:signed_in] != true
            flash[:error] = "You must be logged in to access this section"
            render :template  =>'login/login'
        end

    end


    def get_datetime()  
        months = { 1 =>'Jan', 2 =>'Feb', 3 => 'Mar', 4 => 'Apr', 
             5 => 'May', 6 => 'Jun', 7 => 'Jul', 8 => 'Aug', 
             9 => 'Sep', 10 => 'Oct', 11 => 'Nov', 12 => 'Dec' }
             
        day_weeks = {0 => 'Sunday', 1 => 'Monday', 2 => 'Tuesday', 3 => 'Wednesday', 4 => 'Thursday',
            5 => 'Friday', 6 => 'Saturday'}

        t = Time.now 
        curr_month = months[t.month]
        day = t.day
        year = t.year   
        day_week = day_weeks[t.wday]
        curr_date = day_week + ", " + curr_month + " " + day.to_s + " " + year.to_s
        hour = t.hour 
        curr_time = ""

        if hour > 12 
            hour = hour - 12
            if t.min < 10 
                curr_time = hour.to_s + ":" + "0" + (t.min).to_s + " PM"
            else 
                curr_time = hour.to_s + ":" + (t.min).to_s + " PM"
            end
        elsif hour == 12
            if t.min < 10
                curr_time = hour.to_s + ":" + "0" + (t.min).to_s + " PM" 
            else 
                curr_time = hour.to_s + ":" + (t.min).to_s + " PM" 
            end
        elsif hour == 0 
            hour = 12
            if t.min < 10
                curr_time = "12:" + "0" + (t.min).to_s + " AM" 
            else 
                curr_time = "12:" + (t.min).to_s + " AM" 
            end
        else 
            if t.min < 10 
                curr_time = hour.to_s + ":" + "0" + (t.min).to_s + " AM"
            else 
                curr_time = hour.to_s + ":" + (t.min).to_s + " AM"
            end
        end

        return {"date_posted" => curr_date, "time_posted" => curr_time}

    end





end
