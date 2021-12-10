class AddMealToEnergys < ActiveRecord::Migration[6.1]
  def change
    add_column :energies, :meal, :integer
  end
end
