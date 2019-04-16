class AddColumnAppuserIdToCategoryRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :category_requests, :appuser_id, :string, before: :created_at
  end
end
