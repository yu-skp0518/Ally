class Public::InquiriesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]
  
  def new
  end

  def create
  end

  def update
  end
end
