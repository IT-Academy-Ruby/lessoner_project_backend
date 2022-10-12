# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :user_find, only: %i[show]

  def show; end

  def check_username
    @user = User.find_by(name: params[:name])
  end

  private

  def user_find
    @user = User.find(params[:id])
  end
end
