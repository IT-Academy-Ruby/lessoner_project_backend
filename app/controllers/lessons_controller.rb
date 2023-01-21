class LessonsController < ApplicationController
  before_action :lesson_find, only: %i[show edit update destroy]
  before_action :for_registered_user, only: %i[create update destroy]

  def index
    @pagy, @lessons = pagy(Lesson.filter(lesson_params.slice(:status,
                                                             :category_id)).order(sort_params))
  end

  def show
    if @lesson
      @views_count = @lesson.lesson_views.size
      check_user_rating
      set_lesson_image_params
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
    set_lesson_image_params
    set_video_link
    set_image_link
    if @lesson.save
      render :show
    else
      render :error, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if lesson_rating_params.present?
      service_result = CalculateLessonsRatingService.new(@lesson, current_user, lesson_rating_params[:rating]).call
      return render json: { error: service_result.message } unless service_result.success?
    end

    if @lesson.update(lesson_params)
      set_user_rating
      set_lesson_image_params
      set_video_link
      set_image_link

      render :show
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
    params.permit(:title, :description, :status, :video_link, :author_id, :category_id, :created_at, :lesson_image,
                  :lesson_video, :image_link)
  end

  def lesson_rating_params
    params.permit(:rating)
  end

  def lesson_find
    @lesson = Lesson.find_by(id: params[:id])
  end

  def set_video_link
    return if params[:lesson_video].blank?

    @lesson.video_link = @lesson.lesson_video&.url&.split('?')&.first
    @lesson.save!
  end

  def set_lesson_image_params
    @image_name = @lesson.lesson_image&.filename
    @image_size = @lesson.lesson_image&.byte_size
  end

  def set_image_link
    return if params[:lesson_image].blank?

    @lesson.image_link = @lesson.lesson_image&.url&.split('?')&.first
    @lesson.save!
  end

  def set_user_rating
    @user_rating = @lesson.lesson_ratings.find_by(user_id: current_user).rating
  end
end
