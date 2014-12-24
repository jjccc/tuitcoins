class UsersController < ApplicationController

  # GET /users
  def index
    @users_count = User.all.count
    @followers_count = User.followers
    @paginable_users = User.order("created_at desc").page(params[:page])
    @users = UserDecorator.decorate_collection(@paginable_users)
  end

end
