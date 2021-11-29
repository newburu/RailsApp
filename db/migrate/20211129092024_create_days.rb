class CreateDays < ActiveRecord::Migration[6.1]
  def change
    create_table :days do |t|
      t.float :weight
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
