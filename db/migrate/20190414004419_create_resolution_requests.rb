class CreateResolutionRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :resolution_requests do |t|
      t.string :id_code
      t.string :plain_code
      t.string :app_id, index: true
      t.references :user
      t.integer :category_number
      t.string :sample_value
      t.string :gps
      t.datetime :sample_time
      t.string :resolution_result
      t.integer :formula_version
      t.string :hardware_id
      t.string :request_ip
      t.integer :return_status

      t.timestamps
    end
  end
end
