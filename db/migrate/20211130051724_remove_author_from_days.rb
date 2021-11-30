class RemoveAuthorFromDays < ActiveRecord::Migration[6.1]
  def change
    remove_column :days, :Date, :time
  end
end
