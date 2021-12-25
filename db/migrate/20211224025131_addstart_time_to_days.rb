class AddstartTimeToDays < ActiveRecord::Migration[6.1]
  def change
    add_column :days, :start_time, :datetime
  end
end
