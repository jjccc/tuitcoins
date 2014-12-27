class UsersController < ApplicationController

  # GET /users
  def index
    @users_count = User.all.count
    @scope = User.scope
    @paginable_users = User.order("created_at desc").page(params[:page])
    @users = UserDecorator.decorate_collection(@paginable_users)
  end
  
  # GET /users/1
  def show
    @campaigns = current_user.campaigns
    
    @campaigns_count = current_user.campaigns.count
    @paginable_campaigns = current_user.campaigns.order(:start_at).page(params[:page])
    @campaigns = CampaignDecorator.decorate_collection(@paginable_campaigns)
    render "campaigns/index"
  end
  
end
