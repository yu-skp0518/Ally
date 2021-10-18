class Public::GenresController < ApplicationController
  before_action :authenticate_user!, only: [:update]
  
  def index
  end

  def update
  end
end
