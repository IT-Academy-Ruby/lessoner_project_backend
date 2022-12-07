# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :for_admin, only: %i[new create edit update]
  before_action :category_find, only: %i[show edit update]

  def index
    @categories = Category.all
  end

  def show
    if @category
      render :show
    else
      render :not_found, status: :not_found
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render :show
    else
      render 'categories/errors', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      render 'categories/show'
    else
      render 'categories/errors', status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.permit(:name, :description, :status)
  end

  def category_find
    @category = Category.find_by(id: params[:id])
  end

  def current_user_id
    @decoded = JsonWebToken.decode(jwt_token)
    @current_user = User.find_by(email: @decoded['email'])
  rescue
    nil
  end

  def for_admin
    if jwt_token.present?
      render json: { error: "You don't have permission to access" }, status: :forbidden unless current_user.admin_type?
    else
      render json: { error: "You don't have permission to access" }, status: :forbidden
    end
  end
end
