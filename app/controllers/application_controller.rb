class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate, :current_user
  
  def authenticate
    if user_not_granted? 
      authenticate_or_request_with_http_basic do |user_name, password|
        user_name == Tuitcoins::Application.config.http_user && password == Tuitcoins::Application.config.http_password
      end
    end
  end
  
  def current_user
    User.find_by_id(session[:user_id]) unless session[:user_id].blank?
  end
  
  def forbid
    render(:file => 'public/500.html', :status => :forbidden, :layout => false)
  end

  private 
  
  def user_not_granted?
    ["dashboards", "campaigns"].include?(params[:controller])
  end

  
end
