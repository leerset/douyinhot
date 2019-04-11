class CreateCategoryFormulas < ActiveRecord::Migration[5.2]
  def change
    create_table :category_formulas do |t|
      t.integer :category_number, index: true
      t.string :formula
      t.integer :top_limit
      t.integer :version, null: false, default: 1

      t.timestamps
    end
  end
end
