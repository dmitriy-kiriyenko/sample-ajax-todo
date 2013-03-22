class AddUserIdToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :user_id, :integer, null: false

    add_index :todos, :user_id
  end
end
