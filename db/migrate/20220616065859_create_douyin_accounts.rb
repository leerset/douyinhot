class CreateDouyinAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :douyin_accounts do |t|
      t.string :name
      t.string :number
      t.string :url
      t.integer :hot_threshold

      t.timestamps
    end
  end
end
