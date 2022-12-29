class MyStudiosController < AuthorizationController
  def index
    @pagy, @lessons = pagy(current_user.lessons)
  end
end
