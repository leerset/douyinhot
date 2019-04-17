class AddColumnTimestampToCategoryRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :category_requests, :time_stamp, :integer, before: :created_at
  end
end
