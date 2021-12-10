class Energy < ApplicationRecord
  belongs_to :user
  enum meal: {morning: 0, lunch: 1, night: 3, snack: 4}
end