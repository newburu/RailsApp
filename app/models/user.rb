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
end
