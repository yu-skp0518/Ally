class Admin::RelationshipsController < ApplicationController
  before_action :authenticate_admin!
  
  def followings
  end

  def followers
  end
end
