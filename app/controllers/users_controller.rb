class UsersController < ApplicationController

  # GET /users
  def index
    @users_count = User.all.count
    @scope = User.scope
    @paginable_users = User.order("created_at desc").page(params[:page])
    @users = UserDecorator.decorate_collection(@paginable_users)
  end
  
  # GET /users/new
  def new
    render :layout => false
  end

end
