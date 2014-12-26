class SessionsController < ApplicationController

  def create 
    #raise request.env["omniauth.auth"].to_yaml  
    auth = request.env["omniauth.auth"]  
    user = User.find_by_uid(auth["uid"]) || User.create_with_omniauth(auth)
    redirect_to root_url
  end  
  
end
