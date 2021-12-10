class AddDateToEnergys < ActiveRecord::Migration[6.1]
  def change
    add_column :energies, :date, :date
  end
end
