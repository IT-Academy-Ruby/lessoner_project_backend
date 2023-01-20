class LessonViewsController < ApplicationController
  def add_view
    @lesson_view = LessonView.new(ip: client_ip, lesson_id: params[:lesson_id], user_id: current_user_id)
    if @lesson_view.save
      update_views_count
      render :show
    else
      render :error, status: :unprocessable_entity
    end
  end

  private

  def current_user_id
    @decoded = JsonWebToken.decode(jwt_token)
    @current_user_id = User.find_by(email: @decoded['email']).id
  rescue
    nil
  end

  def update_views_count
    @lesson = Lesson.find_by(id: params[:lesson_id])
    @lesson.views_count = @lesson.lesson_views.size
    @lesson.save
  end
end
