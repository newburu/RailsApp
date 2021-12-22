class EnergysController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :list, :edit, :destroy, :edit, :update]
  def index
    @today = Date.today
    @day_weight = current_user.days.find_by(date: Date.today)
    #目標体重を計算
    @goal_weight =  (current_user.weight*0.95).round(2)
    #ログインしているユーザーの今日の日付を全件取得（配列）
    energys = current_user.energys.where(date: @today)
    #メイン画面で適性を超えてるのかを計算して表示する
    @protein_amounts_sum = energys.pluck(:protein).sum
    @sugar_amounts_sum = energys.pluck(:sugar).sum
    @kcal_amounts_sum = energys.pluck(:kcal).sum
    
    if params[:date_year]
      @date = Date.new params[:date_year].to_i, params[:date_month].to_i, params[:date_day].to_i
      #メイン画面のグラフに使う
      @day_weights = current_user.days.distinct.pluck(:date)
      # binding.pry
    end

  end

  def new
   @energy = Energy.new#Energyモデルのインスタンスを作る
  end

  def create
    #ストロングパラメータを渡してインスタンスを作ってインスタンス変数に代入
    @energy = current_user.energys.build(energy_params)
    date = Date.new energy_params["date(1i)"].to_i, energy_params["date(2i)"].to_i,energy_params["date(3i)"].to_i
    #登録する食事が既にDBにあるかを確認する
    confirmation_data = current_user.energys.exists?(date: date, meal: energy_params[:meal])
            #  binding.pry
    if @energy.meal == "snack"
      @energy.save
      redirect_to energys_path, notice: '登録しました'
    elsif confirmation_data
      flash.now[:alert] = "既に登録されています"
      render :new
    else
      @energy.save
      redirect_to energys_path, notice: '登録しました' 
    end
  end

  def list#(date: Date.today)
    #最初にデフォルトで今日のインスタンスを表示
    @date = Date.today
    @energys = current_user.energys.where(date: Date.today)
    #編集されたらその日付をviewに渡す
    if params[:date_year]
      @date = Date.new params[:date_year].to_i, params[:date_month].to_i,params[:date_day].to_i
      @energys = current_user.energys.where(date: @date)
    end
    #viewで入力された日付に紐づいたインスタンス
    if params["date(1i)"]
      #日付を連結してdateカラムで検索できるようにした
      @date = Date.new params["date(1i)"].to_i, params["date(2i)"].to_i,params["date(3i)"].to_i
      #ログインしてるユーザーに紐付いたエネルギーモデルのインスタンスで日付をviewから取ってその日付をdateカラムから検索したい
      @energys = current_user.energys.where(date: @date)
    end
  end


  def edit
    @energy = Energy.find(params[:id])
  end

  def update
    @energys = Energy.find(params[:id])
    if @energys.update(energy_params)
      flash[:notice] = '更新しました'
      redirect_to controller: 'energys', action: 'list', date_year: params[:energy]["date(1i)"], date_month: params[:energy]["date(2i)"], date_day: params[:energy]["date(3i)"]
    else
      render :edit
    end
  end

  def destroy
    energy = Energy.find(params[:id])
    if energy.user_id == current_user.id#もしログインしているユーザーのidと一致したら消去
      energy.destroy
      redirect_to list_energy_path, notice: '削除しました'#一覧ページに戻る
    end
  end

  private
    def energy_params#ストロングパラメーターでタンパク質と糖質とカロリーと日付と食事のみを保存するようにしている
      params.require(:energy).permit(:protein, :sugar, :kcal, :meal, :date)
    end
    
end

