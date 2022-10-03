# frozen_string_literal: true

class LessonsController < ApplicationController
  before_action :lesson_find, only: %i[show edit update]
  def index
    @lessons = Lesson.all
  end

  def show
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = current_user.lessons.new(lesson_params)
    if @lesson.save
      redirect_to @lesson
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @lesson.update(lesson_params)
      redirect_to @lesson
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lesson.destroy
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :description, :status, :video_link, :author_id, :category_id)
  end

  def lesson_find
    @lesson = Lesson.all.find(params[:id])
    rescue StandardError => e
      render json: {error: e}, status: :not_found
  end
end
