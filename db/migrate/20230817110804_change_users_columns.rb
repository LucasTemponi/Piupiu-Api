class ChangeUsersColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :email, :handle
    add_column :users, :name, :string
  end
end
