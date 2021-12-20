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

  #男性のカロリー
  def my_kcal
    if exercise == "everytime" and gender == "man" 
      2600-kcal_amounts_sum
    elsif exercise == "Sometimes" and gender == "man"
      2400-kcal_amounts_sum
    elsif execire == "donot" and gender == "man"
      2200-kcal_amounts_sum
    end
  end

  #男性のタンパク質
  def my_protein
    if self.exercise == "everytime" and self.gender == "man"
      (user.weight*1.2).round(0)-protein_amounts
    elsif self.exercise == "Sometimes" and self.gender == "man"
      (user.weight*1).round(0)-protein_amounts
    else self.exercise == "donot" and self.gender== "man"
      (user.weight*1).round(0)-protein_amounts
    end
  end

  #男性の糖質
  def my_sugar
    if exercise == "everytime" and gender == "man"
      390-sugar_amounts_sum
    elsif exercise == "Sometimes" and gender == "man"
      360-sugar_amounts_sum
    else exercise == "donot" and gender== "man"
      330 -sugar_amounts_sum
    end
  end

end
