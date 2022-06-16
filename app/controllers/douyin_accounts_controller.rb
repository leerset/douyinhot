class DouyinAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_douyin_account, only: %i[edit update destroy]

  # GET /douyin_accounts/new.
  # Create a new API key.
  def new
    @douyin_account = DouyinAccount.new
  end

  # GET /douyin_accounts.
  def index
    @douyin_accounts = DouyinAccount.all
  end

  # POST /douyin_accounts.
  # Create an API key.
  def create
    @douyin_account = DouyinAccount.new(douyin_account_params)
    if @douyin_account.save
      flash[:success] = Messages::CREATED
      redirect_to douyin_accounts_path
    else
      render 'new'
    end
  end

  # PATCH /douyin_accounts/1.
  # Update an API key.
  def update
    if @douyin_account.update_attributes(douyin_account_params)
      flash[:toastr_success] = Messages::UPDATED
      redirect_to douyin_accounts_path
    else
      render 'edit'
    end
  end

  # DELETE /douyin_accounts/1.
  # Destroy an API key.
  def destroy
    @douyin_account.destroy
    flash[:toastr_success] = Messages::DELETED
    redirect_to douyin_accounts_path
  end

  private

  # Set API key.
  def set_douyin_account
    @douyin_account = DouyinAccount.find(params[:id])
  end

  # Sanitize API key params.
  def douyin_account_params
    params.require(:douyin_account).permit(:name, :number, :url, :hot_threshold)
  end
end
