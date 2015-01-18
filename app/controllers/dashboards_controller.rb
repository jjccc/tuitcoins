class DashboardsController < ApplicationController

  def index
    @users_count = User.all.count
    @apps = App.order(:name)
    @scope = User.scope
    @paginable_users = User.order("created_at desc").page(params[:page])
    @users = UserDecorator.decorate_collection(@paginable_users)
    @evolution = Evolution.new(15)
  end
  
end