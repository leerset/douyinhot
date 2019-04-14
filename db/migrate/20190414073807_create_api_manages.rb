class CreateApiManages < ActiveRecord::Migration[5.2]
  def change
    create_table :api_manages do |t|
      t.string :api_name
      t.integer :manage

      t.timestamps
    end
  end
end
