class CreateCategoryRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :category_requests do |t|
      t.string :id_code
      t.string :app_id, index: true
      t.references :user
      t.datetime :request_time
      t.integer :request_status
      t.integer :release_status
      t.string :request_ip

      t.timestamps
    end
  end
end
