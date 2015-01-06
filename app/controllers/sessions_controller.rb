class SessionsController < ApplicationController

  def numberaffinity
    render :layout => "login"
  end
  
  def cloudtag
    render :layout => "login"
  end
  
  def destroy
    session[:user_id] = nil
    render "new", :layout => "login"
  end
  
  def callback
    @app = App.find_by_subdomain(params[:app])
    create_user
  end

  private 
  
  def create_user
    auth = request.env["omniauth.auth"]
    user = User.find_by_uid_and_app_id(auth["uid"], @app.id) 
    if user.nil? 
      user = User.create_with_omniauth(auth, @app)
      user.create_default_campaigns
    end
    session[:user_id] = user.id
    redirect_to user_url(user.id), :layout => "application"
  end
  
end
