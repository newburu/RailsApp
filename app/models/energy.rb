class Energy < ApplicationRecord
  belongs_to :user
  enum meal: {morning: 0, lunch: 1, night: 2, snack: 3}
  with_options presence: true do
  validates :protein
  validates :sugar
  validates :kcal
  validates :meal
  validates :date
  end
end