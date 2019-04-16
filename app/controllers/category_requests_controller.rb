class CategoryRequestsController < ApplicationController
  before_action :set_category_request, only: %i[show edit update destroy]

  # GET /category_requests/new.
  # Create a new API key.
  def new
  end

  # GET /category_requests.
  def index
    @category_requests = CategoryRequest.all.order(created_at: :desc)
  end

  def show
  end

  # POST /category_requests.
  # Create an API key.
  def create
  end

  # PATCH /category_requests/1.
  # Update an API key.
  def update
  end

  # DELETE /category_requests/1.
  # Destroy an API key.
  def destroy
  end

  private

  # Set API key.
  def set_category_request
    id = params[:id] || params[:category_request_id]
    @category_request = CategoryRequest.find(id)
  end

  # Sanitize API key params.
  def category_request_params
    params.require(:category_request).permit()
  end
end
