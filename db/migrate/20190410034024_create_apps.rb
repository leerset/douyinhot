class CreateApps < ActiveRecord::Migration[5.2]
  def change
    create_table :apps do |t|
      t.string :app_name, index: true
      t.string :app_id, index: true
      t.string :app_key
      t.string :app_secret
      t.string :firm_name
      t.string :paltform
      t.datetime :registration_time
      t.integer :status
      t.text :comment

      t.timestamps
    end
  end
end
