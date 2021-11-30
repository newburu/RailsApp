class AddDayToDate < ActiveRecord::Migration[6.1]
  def change
    add_column :days, :Date, :Time
  end
end
