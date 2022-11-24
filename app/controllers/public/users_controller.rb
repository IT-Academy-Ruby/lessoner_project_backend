# frozen_string_literal: true

module Public
  class UsersController < ApplicationController
    def check_username
      @user = User.find_by(name: params[:name])
    end

    def check_email
      @user = User.find_by(email: params[:email])
    end
  end
end
