class Delete < ActiveRecord::Migration[6.1]
  def change
  drop_table :days
  end
end
