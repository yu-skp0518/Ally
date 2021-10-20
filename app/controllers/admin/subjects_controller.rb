class Admin::SubjectsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @subjects = Subject.all
    @subject = Subject.new
  end

  def create
    @subjects = Subject.all
    @subject = Subject.new(subject_params)
    if @subject.save
      @subjects = Subject.all
    else
      @subjects = Subject.all
      render 'admin/subject#index'
    end
  end

  def show
    @subjects = Subject.all
    @subject = Subject.find(params[:id])
    @books = @subject.book.page(params[:page]).per(20)
    @amount = @subject.items.count
  end


  def edit
    @subject = Subject.find(params[:id])
  end

  def update
    @subject = Subject.find(params[:id])
    if @subject.update(subject_params)
      redirect_to admin_subjects_path
    else
      render 'admin/subject#edit'
    end
  end

  def destroy
  end

  private
  def subject_params
    params.require(:subject).permit(:name)
  end
end
