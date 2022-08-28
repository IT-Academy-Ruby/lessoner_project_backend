class CommentsController < ApplicationController

 def create
    @lesson = Lesson.find(params[:lesson_id])
    @comment = @lesson.comments.create!(comment_params.merge(user:current_user))
    if @comment.save
      flash[:success] = "Comment successfully added"
      redirect_to lesson_path(@lesson)
    else
      flash[:success] = "Comment not posted"
      redirect_to lesson_path(@lesson)
    end
 end

 def edit
 end

 def update
   if @comment.update(comment_params)
     redirect_to lesson_path(@lesson)
   else
     render :edit, status: :unprocessable_entity
   end
 end

  def destroy
    @lesson = Lesson.find(params[:lesson_id])
    @comment = @lesson.comment.find(params[:id])
    return render :file => "public/403.html", :status => :unauthorized if @comment.user != current.user
    @comment.destroy
    redirect_to lesson_path(@lesson), status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
