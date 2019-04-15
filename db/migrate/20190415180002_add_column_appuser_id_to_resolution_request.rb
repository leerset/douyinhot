class AddColumnAppuserIdToResolutionRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :resolution_requests, :appuser_id, :string, before: :created_at
  end
end
