# frozen_string_literal: true

class CommentsController < AuthorizationController
  before_action :find_comment, only: %i[update destroy]

  def index
    @pagy, @comments = pagy(Lesson.find_by(id: params[:lesson_id]).comments.order(sort_params))
  end

  def create
    @comment = current_user.comments.create(comment_params)
    if @comment.save
      render :create
    else
      render :errors, status: :bad_request
    end
  end

  def update
    if @comment.update(comment_params)
      render :update
    else
      render :errors, status: :bad_request
    end
  end

  def destroy
    return render json: { error: 'unauthorized' }, status: :unauthorized if @comment.user != current_user

    @comment.destroy
  end

  private

  def find_comment
    @comment = Comment.find_by(lesson_id: params[:lesson_id], id: params[:id])
    return render json: { error: 'not found' }, status: :not_found unless @comment
  end

  def comment_params
    params.permit(:user_id, :body, :lesson_id)
  end
end
