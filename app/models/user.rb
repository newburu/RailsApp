class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :energys
  enum gender: {man: 0, woman: 1}
  enum exercise: {everytime: 0, Sometimes: 1, donot: 2}

  with_options on: :confirm do
    validates_presence_of :name, length: {maximum:6}
    validates_presence_of :gender
    validates_presence_of :weight
    validates_presence_of :height
    validates_presence_of :exercise
  end
end
