class EnergysController < ApplicationController
  before_action :authenticate_user!, only: [:index,:record,:new,:create,:weight]
  def index
    @user = current_user
  end

  def new
   @user = current_user#ログインしてるユーザーを代入
   @energy = Energy.new#Energyモデルのインスタンスを作る
  end

  def create
    #binding.pry
    #@energy =Energy.new(energy_params)#ストロングパラメータを渡してインスタンスを作ってインスタンス変数に代入
    @energy = current_user.energys.build(energy_params)
    if @energy.save
     redirect_to energys_path, notice: '登録しました'
    else 
     render :new
    end
  end

  def weight
  end

  def record
  end

  private
    def energy_params#ストロングパラメーターでタンパク質と糖質とカロリーのみを保存するようにしている
      params.require(:energy).permit(:protein, :sugar, :kcal)#s, :user_id)
    end
end
