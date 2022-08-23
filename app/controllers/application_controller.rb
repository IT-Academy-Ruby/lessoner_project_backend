class ApplicationController < ActionController::Base
  def hello
   render html: "hello world3!"
  end
end
