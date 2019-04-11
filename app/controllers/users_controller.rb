class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]

  # GET /users/new.
  # Create a new API key.
  def new
    @user = User.new
  end

  # GET /users.
  def index
    @users = User.all
  end

  # POST /users.
  # Create an API key.
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = user_created_msg
      redirect_to users_path
    else
      render 'new'
    end
  end

  # PATCH /users/1.
  # Update an API key.
  def update
    if @user.update_attributes(user_params)
      flash[:toastr_success] = Messages::API_KEY_UPDATED
      redirect_to users_path
    else
      render 'edit'
    end
  end

  # DELETE /users/1.
  # Destroy an API key.
  def destroy
    @user.destroy
    flash[:toastr_success] = Messages::API_KEY_DELETED
    redirect_to users_path
  end

  private

  # Set API key.
  def set_user
    @user = User.find(params[:id])
  end

  # Build flash message to render on successful create.
  def user_created_msg
    "#{Messages::API_KEY_CREATED}<br>#{Constants::API_KEY_HEADER}: "\
    "#{@user_value}<br>#{Messages::SAVE_API_KEY}"
  end

  # Sanitize API key params.
  def user_params
    params.require(:user).permit(:user_name, :email, :password)
  end
end
