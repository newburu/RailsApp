class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable
  has_many :energys
  has_many :days
  enum gender: {man: 0, woman: 1}
  enum exercise: {everytime: 0, Sometimes: 1, donot: 2}

  VALID_PASSWORD_REGEX =/\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[\d])\w{6,12}\z/
  validates :password, on: :create, presence: true, confirmation: true, format: { with: VALID_PASSWORD_REGEX, message: "は半角6~12文字英大文字・小文字・数字それぞれ１文字以上含む必要があります"}
  validates :password, on: :update, presence: true, confirmation: true, format: { with: VALID_PASSWORD_REGEX, message: "は半角6~12文字英大文字・小文字・数字それぞれ１文字以上含む必要があります"}, allow_nil: true
  validates :email, on: :create, presence: true, uniqueness: true

  with_options on: :create do
    validates_presence_of :name, length: {maximum:6}
    validates_presence_of :gender, allow_nil: true
    validates_presence_of :weight, allow_nil: true
    validates_presence_of :height, allow_nil: true
    validates_presence_of :exercise, allow_nil: true
  end
end