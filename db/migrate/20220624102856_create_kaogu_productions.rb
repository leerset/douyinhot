class CreateKaoguProductions < ActiveRecord::Migration[5.2]
  def change
    create_table :kaogu_productions do |t|
      t.string :rank
      t.string :name
      t.string :link
      t.string :imageUrl
      t.string :nowPrice
      t.string :oldPrice
      t.string :commissionRate
      t.string :videSales
      t.string :views
      t.string :videoCount

      t.timestamps
    end
  end
end
