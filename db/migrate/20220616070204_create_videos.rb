class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.references :douyin_account
      t.string :name
      t.string :number
      t.string :tag
      t.string :url
      t.integer :like
      t.integer :comment
      t.integer :attention
      t.datetime :release_time

      t.timestamps
    end
  end
end
