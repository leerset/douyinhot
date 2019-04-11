class AppsController < ApplicationController
  before_action :set_app, only: %i[edit update destroy]

  # GET /apps/new.
  # Create a new API key.
  def new
    @app = App.new
  end

  # GET /apps.
  def index
    @apps = App.all
  end

  # POST /apps.
  # Create an API key.
  def create
    @app = App.new(app_params)
    if @app.save
      flash[:success] = Messages::CREATED
      redirect_to apps_path
    else
      render 'new'
    end
  end

  # PATCH /apps/1.
  # Update an API key.
  def update
    if @app.update_attributes(app_params)
      flash[:toastr_success] = Messages::UPDATED
      redirect_to apps_path
    else
      render 'edit'
    end
  end

  # DELETE /apps/1.
  # Destroy an API key.
  def destroy
    @app.destroy
    flash[:toastr_success] = Messages::DELETED
    redirect_to apps_path
  end

  private

  # Set API key.
  def set_app
    @app = App.find(params[:id])
  end

  # Sanitize API key params.
  def app_params
    params.require(:app).permit(
      :app_name, :app_id, :firm_name, :paltform, :registration_time, :status, :comment
    )
  end
end
