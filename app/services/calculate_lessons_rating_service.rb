class CalculateLessonsRatingService
  def self.build(lesson_id:, current_user_id:, rating:)
    lesson = Lesson.find(lesson_id)
    current_user = User.find(current_user_id)
    new(lesson, current_user, rating)
  end

  def initialize(lesson, current_user, rating)
    @lesson = lesson
    @current_user = current_user
    @rating = rating
  end

  def call
    Rails.logger.info("- Start #{self.class.name} with lesson: #{@lesson}")

    ActiveRecord::Base.transaction do
      create_lesson_rating
      update_lesson_rating
      update_lesson
      set_votes
    end

    Rails.logger.info("- Finish #{self.class.name} with lesson: #{@lesson}")
    ServiceResult.new status: true, data: @lesson
  rescue StandardError => e
    ServiceResult.new(
      status: false,
      exception: e
    )
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

  def set_votes
    @lesson.votes_count = @lesson.lesson_ratings.size
  end
  
  def create?
    @current_user.lesson_ratings.pluck(:lesson_id).exclude? @lesson.id
  end
end
