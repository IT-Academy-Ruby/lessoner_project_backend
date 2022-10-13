# frozen_string_literal: true

class LessonsController < ApplicationController
  before_action :lesson_find, only: %i[show edit update destroy]
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
    if @lesson&.destroy
      render :destroy
    else
      render :error, status: :unprocessable_entity
    end
  end

  private

  def lesson_params
    params.permit(:title, :description, :status, :video_link, :author_id, :category_id)
  end

  def lesson_find
    @lesson = Lesson.all.find_by(id: params[:id])
  end
end
