class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable#, :validatable
  has_many :energys
  has_many :days
  enum gender: {man: 0, woman: 1}
  enum exercise: {everytime: 0, Sometimes: 1, donot: 2}

  VALID_PASSWORD_REGEX =/\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[\d])\w{6,12}\z/
  validates :password, presence: true,
            format: { with: VALID_PASSWORD_REGEX,
             message: "は半角6~12文字英大文字・小文字・数字それぞれ１文字以上含む必要があります"},
             confirmation: true
  with_options on: :confirm do
    validates_presence_of :name, length: {maximum:6}
    validates_presence_of :gender
    validates_presence_of :weight
    validates_presence_of :height
    validates_presence_of :exercise
  end
  #  binding.pry 

    #男性のカロリー
  # def my_kcal
  #   user = User.find(60)
  #   if exercise == "everytime" and gender == "man" 
  #     2600-kcal_amounts_sum
  #   elsif exercise == "Sometimes" and gender == "man"
  #     2400-kcal_amounts_sum
  #   elsif execire == "donot" and gender == "man"
  #     2200-kcal_amounts_sum
  #   end
  # end

  # # 男性のタンパク質
  # def my_protein
    

  #   if self.exercise == "everytime" and self.gender == "man"
  #     (user.weight*1.2).round(0)-protein_amounts_sum
  #   elsif self.exercise == "Sometimes" and self.gender == "man"
  #     (user.weight*1).round(0)-protein_amounts_sum
  #   else self.exercise == "donot" and self.gender== "man"
  #     (user.weight*1).round(0)-protein_amounts_sum
  #   end
  # end

  # # 男性の糖質
  # def my_sugar
  #   if exercise == "everytime" and gender == "man"
  #     390-sugar_amounts_sum
  #   elsif exercise == "Sometimes" and gender == "man"
  #     360-sugar_amounts_sum
  #   else exercise == "donot" and gender== "man"
  #     330 -sugar_amounts_sum
  #   end
  # end

end
