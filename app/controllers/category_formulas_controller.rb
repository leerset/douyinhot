    class CategoryFormulasController < ApplicationController
  before_action :set_category_formula, only: %i[show edit update destroy]

  # GET /category_formulas/new.
  # Create a new API key.
  def new
    @category_formula = CategoryFormula.new
  end

  def show
  end

  # GET /category_formulas.
  def index
    @category_formulas = CategoryFormula.all
  end

  # POST /category_formulas.
  # Create an API key.
  def create
    @category_formula = CategoryFormula.new(category_formula_params)
    if @category_formula.save
      flash[:success] = Messages::CREATED
      redirect_to category_formulas_path
    else
      render 'new'
    end
  end

  # PATCH /category_formulas/1.
  # Update an API key.
  def update
    if @category_formula.update_attributes(category_formula_params)
      flash[:toastr_success] = Messages::UPDATED
      redirect_to category_formulas_path
    else
      render 'edit'
    end
  end

  # DELETE /category_formulas/1.
  # Destroy an API key.
  def destroy
    @category_formula.destroy
    flash[:toastr_success] = Messages::DELETED
    redirect_to category_formulas_path
  end

  private

  # Set API key.
  def set_category_formula
    @category_formula = CategoryFormula.find(params[:id])
  end

  # Sanitize API key params.
  def category_formula_params
    params.require(:category_formula).permit(:category_number, :formula, :top_limit)
  end
end
