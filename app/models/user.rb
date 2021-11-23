class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  has_many :energys
  enum gender: {man: 0, woman: 1}
  enum exercise: {everytime: 0, Sometimes: 1, donot: 2}

  with_options presence: true do
    validates :name, length: {maximum:6}
    # validates :gender
    # validates :weight
    # validates :height
    # validates :exercise
  end
end
