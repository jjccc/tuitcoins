class SessionsController < ApplicationController

  def create 
    auth = request.env["omniauth.auth"]  
    user = User.find_by_uid(auth["uid"]) || User.create_with_omniauth(auth)
    user.create_default_campaigns
    session[:user_id] = user.id
    redirect_to user_url(user.id)
  end
  
  def destroy
    session[:user_id] = nil
    render :layout => false
  end
  
end
