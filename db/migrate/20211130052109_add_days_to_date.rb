class AddDaysToDate < ActiveRecord::Migration[6.1]
  def change
    add_column :days, :date, :Date
  end
end
