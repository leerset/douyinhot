class AddColumnUserNameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_name, :string, null: false, default: '管理员', before: :email
  end
end
