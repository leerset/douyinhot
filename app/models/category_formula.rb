class CategoryFormula < ApplicationRecord
  has_many :category_formula_histories
  belongs_to :category, primary_key: :category_number, foreign_key: :category_number

  before_save :increase_version
  after_save :snapshot!

  def increase_version
    self.version += 1
  end

  def snapshot!
    params = CategoryFormulaHistory::WHITE_COLUMN.map { |column| [column, self.send(column)] }
    category_formula_histories.create!(Hash[params])
  end
end
