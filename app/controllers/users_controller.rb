class UsersController < ApplicationController

  # GET /users
  def index
    @users_count = User.all.count
    @apps = App.order(:name)
    @scope = User.scope
    @paginable_users = User.order("created_at desc").page(params[:page])
    @users = UserDecorator.decorate_collection(@paginable_users)
  end
  
  # GET /users/1
  def show    
    @user = User.find_by_id(params[:id])
    
    # Only the current user's page can be shown. 
    if @user.nil? || current_user.nil? || current_user.id != @user.id
      forbid
    else
      # Dynamically we create an app and run it.
      # After this, show the results.
      subdomain = @user.app.subdomain
      @app = eval(subdomain.capitalize).find_by_id(@user.app.id)
      if @app.nil?
        forbid
      else
        @app.run(@user)        
        @app.tweet if params[:just_created].present? && params[:just_created] == "true"
        @must_show_social_buttons = params[:just_created].present? && params[:just_created] == "false"
        render "#{subdomain}/show"
      end
    end
    
    # @campaigns = current_user.campaigns
    
    # @campaigns_count = current_user.campaigns.count
    # @paginable_campaigns = current_user.campaigns.order(:start_at).page(params[:page])
    # @campaigns = CampaignDecorator.decorate_collection(@paginable_campaigns)
    # render "campaigns/index"
  end
  
end
