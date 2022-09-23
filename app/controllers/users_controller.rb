# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :user_find, only: %i[show]

  def show; end

  private

  def user_find
    @user = User.find(params[:id])
  end
end
