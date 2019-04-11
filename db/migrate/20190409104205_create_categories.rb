class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.integer :category_number, index: true
      t.string :category_name, null: false
      t.references :group, null: false
      t.string :image_url
      t.string :standard
      t.string :unit
      t.integer :group_index

      t.timestamps
    end
  end
end
