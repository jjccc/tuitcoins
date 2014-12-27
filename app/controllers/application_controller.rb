class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate, :current_user, :verify_admin_access
  
  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == Tuitcoins::Application.config.http_user && password == Tuitcoins::Application.config.http_password
    end
  end
  
  def current_user
    User.find_by_id(session[:user_id]) unless session[:user_id].blank?
  end
  
  def verify_admin_access
    unless current_user.nil?
      render(:file => 'public/500.html', :status => :forbidden, :layout => false) if user_not_granted?
    end
  end

  private 
  
  def user_not_granted?
    ["users", "sessions", "campaigns"].exclude?(params[:controller]) ||
    (params[:controller] == "users"  && ["show"].exclude?(params[:action])) ||
    (params[:controller] == "sessions"  && ["create"].include?(params[:action]))
  end

  
end
