class Public::GenresController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def index
    @genres = Genre.all
  end

  def update
  end
end
