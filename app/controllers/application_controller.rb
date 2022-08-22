class ApplicationController < ActionController::Base
  def hello
   render html: "hello world2!"
  end
end
