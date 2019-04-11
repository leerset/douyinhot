class CategoryFormulaHistory < ApplicationRecord
  belongs_to :category_formula

  WHITE_COLUMN = ['category_number', 'formula', 'top_limit', 'version', 'created_at', 'updated_at'].freeze
end
