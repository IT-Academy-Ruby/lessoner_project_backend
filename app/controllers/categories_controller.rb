require 'fastimage'

class CategoriesController < ApplicationController
  before_action :for_admin, only: %i[new create edit update destroy]
  before_action :category_find, only: %i[show edit update destroy]
  before_action :show_lessons, only: %i[show edit update]
  before_action :check_size, only: %i[new create edit update]

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
    @category.image.attach(params[:image])
    @category.image_url = @category.image&.url&.split('?')&.first
    if @category.save
      render :show
    else
      render 'categories/errors', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if params[:image].present?
      @category.image.attach(params[:image])
      @category.update!(image_url: @category.image&.url&.split('?')&.first)
    end
    if @category.update(category_params)
      render 'categories/show'
    else
      render 'categories/errors', status: :unprocessable_entity
    end
  end

  def destroy
    if !@category
      render :not_found, status: :not_found
    elsif @category.lessons.size.zero? && @category.destroy
      render 'categories/destroy'
    else
      render json: { error: "You can't delete this category" }, status: :forbidden
    end
  end

  private

  def category_params
    params.permit(:name, :description, :status, :image, :image_url)
  end

  def category_find
    @category = Category.find_by(id: params[:id])
  end

  def show_lessons
    @amount_lessons = @category&.lessons&.size
  end

  def check_size
    width, height = FastImage.size(params[:image]) if params[:image].present?
    return unless  width < 75 || width > 4000 || height < 75 || height > 4000

    render json: { error: 'Image has an invalid size' }, status: :unsupported_media_type
  end
end
