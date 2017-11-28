Rails.application.routes.draw do
  # root of site
  root 'homepage#index'

  # register controller for user registration
  get 'register' => 'register#register'
  post 'register/create' => 'register#create_user'
  # end of regsiter controller


  ### login controller path for user login ###
  get 'login' => 'login#login'
  # path for creating user session id along
  # with robot id to control robot
  post  'login/user' => 'login#login_create'

  get   '/logout'     =>  'login#logout'
  #### end of login controller  ######




  # post request path from front end for camera rotation requests
  # its in the robot_controller rails controller
  get '/robot'      =>    'robot#new'

  get '/robot/index' =>  'robot#index'

  post '/robot/camera'  =>  'robot#control_camera'

  get '/add/robot'   =>   'add_robot#add'

  post '/add/robot'    => 'add_robot#add_post'

  post '/comment'  =>  'robot#comment'

  post '/robot/gps' => 'robot#gps'



  # post request path from front end to move motors
  # its in the robot_controller rails controller
  post '/robot/motors'  => 'robot#control_motor'


  resources :users


end