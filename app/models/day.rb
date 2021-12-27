class Day < ApplicationRecord
  belongs_to :user
  with_options presence: true do
    validates :weight
    validates :date
  end
end