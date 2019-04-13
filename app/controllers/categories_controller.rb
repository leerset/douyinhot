class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy index_up index_down]

  # GET /categories/new.
  # Create a new API key.
  def new
    @category = Category.new
  end

  # GET /categories.
  def index
    @categories = Category.all
  end

  def show
    @group = @category.group
    @categories = @group.categories
  end

  # POST /categories.
  # Create an API key.
  def create
    @category = Category.new(category_params)
    if params[:category][:category_picture_filepath].present?
      category_picture_filepath = params[:category][:category_picture_filepath].tempfile.path
      @category.upload_picture(category_picture_filepath)
    end
    if @category.save
      flash[:success] = Messages::CREATED
      redirect_to categories_path
    else
      render 'new'
    end
  end

  # PATCH /categories/1.
  # Update an API key.
  def update
    if params[:category][:category_picture_filepath].present?
      category_picture_filepath = params[:category][:category_picture_filepath].tempfile.path
      @category.upload_picture(category_picture_filepath)
    end
    if @category.update_attributes(category_params)
      flash[:toastr_success] = Messages::UPDATED
      redirect_to categories_path
    else
      render 'edit'
    end
  end

  # DELETE /categories/1.
  # Destroy an API key.
  def destroy
    @category.destroy
    flash[:toastr_success] = Messages::DELETED
    redirect_to categories_path
  end

  def index_up
    if @category.index_up
      respond_to do |format|
        format.html { redirect_to request.referer, notice: '已成功上移！' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer, notice: '已经在最上面！' }
        format.json { head :no_content }
      end
    end
  end

  def index_down
    if @category.index_down
      respond_to do |format|
        format.html { redirect_to request.referer, notice: '已成功下移！' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referer, notice: '已经在最下面！' }
        format.json { head :no_content }
      end
    end
  end

  private

  # Set API key.
  def set_category
    id = params[:id] || params[:category_id]
    @category = Category.find(id)
  end

  # Sanitize API key params.
  def category_params
    params.require(:category).permit(
      :category_number,
      :category_name,
      :group_id,
      :image_url,
      :standard,
      :unit,
      :group_index
    )
  end
end
