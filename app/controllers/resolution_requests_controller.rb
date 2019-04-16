class ResolutionRequestsController < ApplicationController
  before_action :set_resolution_request, only: %i[show edit update destroy]

  # GET /resolution_requests/new.
  # Create a new API key.
  def new
  end

  # GET /resolution_requests.
  def index
    @resolution_requests = ResolutionRequest.all.order(created_at: :desc)
  end

  def show
  end

  # POST /resolution_requests.
  # Create an API key.
  def create
  end

  # PATCH /resolution_requests/1.
  # Update an API key.
  def update
  end

  # DELETE /resolution_requests/1.
  # Destroy an API key.
  def destroy
  end

  private

  # Set API key.
  def set_resolution_request
    id = params[:id] || params[:resolution_request_id]
    @resolution_request = ResolutionRequest.find(id)
  end

  # Sanitize API key params.
  def resolution_request_params
    params.require(:resolution_request).permit()
  end
end
