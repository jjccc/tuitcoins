class SessionsController < ApplicationController

  def numberaffinity
    @app_name = "numberaffinity"
    render :layout => "login"
  end
  
  def cloudtag
    @app_name = "cloudtag"
    render :layout => "login"
  end
  
  def destroy
    landing_view = current_user.app.subdomain
    session[:user_id] = nil
    render landing_view, :layout => "login"
  end
  
  def callback
    @app = App.find_by_subdomain(params[:app])
    create_user
  end

  private 
  
  def create_user
    is_user_just_created = false
    auth = request.env["omniauth.auth"]
    user = User.find_by_uid_and_app_id(auth["uid"], @app.id) 
    if user.nil? 
      is_user_just_created = true
      user = User.create_with_omniauth(auth, @app)
      #user.create_default_campaigns
    end
    session[:user_id] = user.id
    redirect_to user_url(user.id, {:just_created => is_user_just_created}), :layout => "application"
  end
  
end
