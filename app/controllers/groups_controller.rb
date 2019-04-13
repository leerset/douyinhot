class GroupsController < ApplicationController
  before_action :set_group, only: %i[edit update destroy]

  # GET /groups/new.
  # Create a new API key.
  def new
    @group = Group.new
  end

  # GET /groups.
  def index
    @groups = Group.includes(:group).all
  end

  # POST /groups.
  # Create an API key.
  def create
    @group = Group.new(group_params)
    if @group.save
      flash[:success] = Messages::CREATED
      redirect_to groups_path
    else
      render 'new'
    end
  end

  # PATCH /groups/1.
  # Update an API key.
  def update
    if @group.update_attributes(group_params)
      flash[:toastr_success] = Messages::UPDATED
      redirect_to groups_path
    else
      render 'edit'
    end
  end

  # DELETE /groups/1.
  # Destroy an API key.
  def destroy
    @group.destroy
    flash[:toastr_success] = Messages::DELETED
    redirect_to groups_path
  end

  private

  # Set API key.
  def set_group
    @group = Group.find(params[:id])
  end

  # Sanitize API key params.
  def group_params
    params.require(:group).permit(:group_name, :group_id)
  end
end
