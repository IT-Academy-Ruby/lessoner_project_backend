# frozen_string_literal: true

class LessonsController < ApplicationController
  include Pagy::Backend

  before_action :lesson_find, only: %i[show edit update destroy]
  before_action :for_registered_user, only: %i[create update destroy]

  def index
    sort_field = params[:sort] || 'created_at'
    sort_type = params[:sort_type] || 'DESC'
    @pagy, @lessons = pagy(Lesson.filter(lesson_params.slice(:status,
                                                             :category_id)).order("#{sort_field} #{sort_type}"))
  end

  def show
    if @lesson
      render :show
    else
      render :not_found, status: :not_found
    end
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = Lesson.new(lesson_params)
    if @lesson.save
      render :show
    else
      render :error, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    service_result = CalculateLessonsRatingService.new(@lesson, current_user, lesson_rating_params[:rating]).call
    return render json: { error: service_result.message } unless service_result.success?

    if @lesson.update(lesson_params)
      redirect_to @lesson
    else
      render :error, status: :unprocessable_entity
    end
  end

  def destroy
    if !@lesson
      render :not_found, status: :not_found
    elsif @lesson.destroy
      render :destroy
    else
      render :error, status: :unprocessable_entity
    end
  end

  private

  def lesson_params
    params.permit(:title, :description, :status, :video_link, :author_id, :category_id)
  end

  def lesson_rating_params
    params.permit(:rating)
  end

  def lesson_find
    @lesson = Lesson.find_by(id: params[:id])
  end
end
