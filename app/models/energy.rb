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

    def user.gender
    if exercise == "everytime"  #男性の場合
       2600-kcla_amounts
    elsif exercise == "Sometimes"#女性の場合

    end
end

