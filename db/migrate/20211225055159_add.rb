class Add < ActiveRecord::Migration[6.1]
  def change
    add_column :energies, :start_time, :datetime
  end
end
