# frozen_string_literal: true

module Public
  class UsersController < ApplicationController
    def check_username
      user_name = params[:name] ? params[:name].downcase : nil
      @user = User.find_by(name: user_name)
    end

    def check_email
      user_email = params[:email] ? params[:email].downcase : nil
      @user = User.find_by(email: user_email)
    end
  end
end
