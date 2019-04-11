class CreateCategoryFormulaHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :category_formula_histories do |t|
      t.references :category_formula, index: true
      t.integer :category_number, index: true
      t.string :formula
      t.integer :top_limit
      t.integer :version

      t.timestamps
    end
  end
end
