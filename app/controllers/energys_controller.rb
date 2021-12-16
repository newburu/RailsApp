class EnergysController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :list, :edit]
  def index
    @user = current_user
    @today = Date.today#今日の日付 
    energys = current_user.energys.where(date: @today)#ログインしているユーザーの今日の日付を全件取得（配列）
    protein_amounts = energys.pluck(:protein).sum#配列で取得した値をカラムごとの配列に直してsumメソッドでたす
    sugar_amounts = energys.pluck(:sugar).sum
    kcal_amounts = energys.pluck(:kcal).sum
    if @user.gender == "man"
      if @user.exercise == "everytime"
        (@user.weight*1.2).round(0)-protein_amounts
      else
        (@user.weight*1).round(0)-protein_amounts
      end
      if @user.exercise == "everytime"
        2600-kcal_amounts
      elsif @user.exercise == "Sometimes"
        2400-kcal_amounts
      else
        2200-kcal_amounts
      end
      
      if @user.exercise == "everytime"
        390-sugar_amounts
      elsif @user.exercise == "Sometimes"
        360-sugar_amounts
      else
        330-sugar_amounts
      end
    else
      if @user.exercise == "everytime"
        (@user.weight*1.2).round(0)
      else
        50
      end
      if @user.exercise == "everytime" 
        2200
      elsif @user.exercise == "Sometimes"
        2000
      else
        1800
      end
      if @user.exercise == "everytime"
        330
      elsif @user.exercise == "Sometimes"
        300
      else
        270
      end
    end
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
  
  def show
    @user = current_user
    @energys = current_user.energys.where(date: params[:date])
    @days = current_user.days.where(date: params[:date])
    @day = current_user.energys.order(:date).select(:date)
  end

  def edit

  end

  def destroy
    @energy = Energy.find(params[:id])
    if energy.user_id == current_user.id#もしログインしているユーザーのidと
      energy.destroy#一致したら消去
      render :show#一覧ページに戻る
    end
  end

  private
    def energy_params#ストロングパラメーターでタンパク質と糖質とカロリーと日付と食事のみを保存するようにしている
      params.require(:energy).permit(:protein, :sugar, :kcal, :meal, :date)
    end
end
