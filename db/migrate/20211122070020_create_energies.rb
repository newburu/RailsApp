class CreateEnergies < ActiveRecord::Migration[6.1]
  def change
    create_table :energies do |t|
      t.integer :protein
      t.integer :sugar
      t.integer :kcal

      t.timestamps
    end
  end
end
