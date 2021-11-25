class AddUserToEnergies < ActiveRecord::Migration[6.1]
  def change
    add_reference :energies, :user, foreign_key: true
  end
end
