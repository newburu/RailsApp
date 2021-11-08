class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :gender, :integer
    add_column :users, :weight, :float
    add_column :users, :height, :float
    add_column :users, :exercise, :integer
  end
end
