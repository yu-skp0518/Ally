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
       redirect_to admin_subjects_path
    else
       @subjects = Subject.all
       flash[:failure] = "投稿に失敗しました"
       render 'admin/subject#index'
    end
  end

  def show
    @subject = Subject.find(params[:id])
    @books = @subject.books.all
    @amount = @subject.books.count
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
