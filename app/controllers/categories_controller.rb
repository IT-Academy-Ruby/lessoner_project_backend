# frozen_string_literal: true

class CategoriesController < ApplicationController
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
    params.permit(:name, :description, :status, :created_at)
  end

  def category_find
    @category = Category.find_by(id: params[:id])
  end
end
