class AddColumnsToResolutionRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :resolution_requests, :hardware_version, :string, before: :created_at
    add_column :resolution_requests, :software_version, :string, before: :created_at
    add_column :resolution_requests, :firm_name, :string, before: :created_at
    add_column :resolution_requests, :model_number, :string, before: :created_at
  end
end
