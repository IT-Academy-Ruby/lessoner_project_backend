# frozen_string_literal: true

class LessonsController < ApplicationController
  before_action :lesson_find, only: %i[show edit update]
  def index
    @lessons = Lesson.all
  end

  def show; end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = Lesson.new(lesson_params)
    if @lesson.save
      render 'lessons/show'
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
  end
end
