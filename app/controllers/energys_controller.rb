class EnergysController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :list, :edit]
  def index
    @user = current_user
    @energys = @user.energys.count
    # @energy = Energy.find_by(id: params[:id])#ここが分からない上手く表示されない
  end

  def new
   @user = current_user#ログインしてるユーザーを代入
   @energy = Energy.new#Energyモデルのインスタンスを作る
  end

  def create
    #binding.pry
    @energy = current_user.energys.build(energy_params)#ストロングパラメータを渡してインスタンスを作ってインスタンス変数に代入
    #energysで複数形になってるのはUserモデルと1対多の関係にあるため
    #buildはnewと一緒の役割だけどモデルの関連付ける際はbuildを使う
    if @energy.save
      redirect_to energys_path, notice: '登録しました'
    else 
      render :new
    end
  end

  def list
  end
  private
    def energy_params#ストロングパラメーターでタンパク質と糖質とカロリーと日付と食事のみを保存するようにしている
      params.require(:energy).permit(:protein, :sugar, :kcal, :meal, :date)
    end
end
