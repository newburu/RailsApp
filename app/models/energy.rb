class Energy < ApplicationRecord
  belongs_to :user
  enum meal: {morning: 0, lunch: 1, night: 2, snack: 3}
    with_options on: :confirm do
    validates_presence_of :protein
    validates_presence_of :sugar
    validates_presence_of :kcal
    validates_presence_of :meal
    validates_presence_of :date
  end
end