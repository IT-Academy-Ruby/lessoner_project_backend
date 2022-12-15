class CalculateLessonsRating
  def initialize(lesson:, current_user:, rating:)
    @lesson = lesson
    @current_user = current_user
    @rating = rating
  end

  def call
    ActiveRecord::Base.transaction do
      create_lesson_rating
      update_lesson_rating
      calculate_lesson_rating
      update_lesson
    end
  end

  private

  def update_lesson
    @lesson.update!(rating: calculate_lesson_rating)
  end

  def create_lesson_rating
    LessonRating.create!(user_id: @current_user.id, lesson_id: @lesson.id, rating: @rating) if create?
  end

  def update_lesson_rating
    LessonRating.find_by(user_id: @current_user.id, lesson_id: @lesson.id).update!(rating: @rating)
  end

  def calculate_lesson_rating
    @lesson.lesson_ratings.average(:rating)
  end

  def create?
    @current_user.lesson_ratings.pluck(:lesson_id).exclude? @lesson.id
  end
end
