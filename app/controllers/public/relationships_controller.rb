class Public::RelationshipsController < ApplicationController
    before_action :authenticate_user!

  def create
    current_user.follow(params[:user_id])
    redirect_back fallback_location: root_path
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_back fallback_location: root_path
  end

  def followings
     user = User.find(params[:user_id])
     @users = user.followings.order(created_at: :desc)
  end

  def followers
     user = User.find(params[:user_id])
     @users = user.followers.order(created_at: :desc)
  end
end
