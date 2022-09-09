class LessonsController < ApplicationController
  before_action :lesson_find, only: [:show, :edit, :update]
  def index
    @lessons = Lesson.all
  end

  def show
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = curent_user.lessons.new(lesson_params)
    if @lesson.save
      redirect_to @lesson
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end
private
def lesson_params
  params.require(:lesson).permit(:title, :description, :status, :video_link, :author_id , :category_id)
end

def lesson_find
  @lesson = Lesson.find(params[:id])
end

end
