class AddSalesToKaoguProductions < ActiveRecord::Migration[5.2]
  def change
    add_column :kaogu_productions, :sales, :decimal, {precision: 10, scale: 2, null: false, default: 0.00}
  end
end
