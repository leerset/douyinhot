class ApiManagesController < ApplicationController
  before_action :set_api_manage, only: %i[edit update destroy]

  # GET /api_manages/new.
  # Create a new API key.
  def new
    @api_manage = ApiManage.new
  end

  # GET /api_manages.
  def index
    @api_manages = ApiManage.all
  end

  # POST /api_manages.
  # Create an API key.
  def create
    @api_manage = ApiManage.new(api_manage_params)
    if @api_manage.save
      flash[:success] = Messages::CREATED
      redirect_to api_manages_path
    else
      render 'new'
    end
  end

  # PATCH /api_manages/1.
  # Update an API key.
  def update
    if @api_manage.update_attributes(api_manage_params)
      flash[:toastr_success] = Messages::UPDATED
      redirect_to api_manages_path
    else
      render 'edit'
    end
  end

  # DELETE /api_manages/1.
  # Destroy an API key.
  def destroy
    @api_manage.destroy
    flash[:toastr_success] = Messages::DELETED
    redirect_to api_manages_path
  end

  private

  # Set API key.
  def set_api_manage
    @api_manage = ApiManage.find(params[:id])
  end

  # Sanitize API key params.
  def api_manage_params
    params.require(:api_manage).permit(
      :api_name, :manage
    )
  end
end
