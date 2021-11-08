class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  enum gender: {man: 0,woman: 1}
  enum exercise: {everytime: 0,Sometimes: 1,donot: 2}
  validates :name, presence: true,length: {maximum:6}
  # with_options do
  #   validates :gender,presence: true
  #   validates :weight,presence: true
  #   validates :height,presence: true
  #   validates :exercise,presence: true
  #   end

  with_options presence: true do
    validates :gender
    validates :weight
    validates :height
    validates :exercise
  end
end
