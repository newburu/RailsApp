class EnergysController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :list, :edit]
  def index
    @today = Date.today#今日の日付
    @goal_weight =  (current_user.weight*0.95).round(2)#目標体重を計算
    energys = current_user.energys.where(date: @today)#ログインしているユーザーの今日の日付を全件取得（配列）
    protein_amounts_sum = energys.pluck(:protein).sum#配列で取得した値をカラムごとの配列に直してsumメソッドでたす
    sugar_amounts_sum = energys.pluck(:sugar).sum
    kcal_amounts_sum = energys.pluck(:kcal).sum
    # aptitude_protien_exercise_well = (user.weight*1.2).round(0)#毎日運動する人のタンパク質量（男性）
    # aptitude_protein_exercise_sometimes = (user.weight*1).round(0)#それ以外の人のタンパク質量（男性）
    # @protein_differences_everytime = aptitude_protien_exercise_well-protein_amounts#目安量から今日食べた合計を引いた量(よく運動する人)
    # @man_protein_difference_sometimes = aptitude_protein_exercise_sometimes-protein_amounts#目安量から今日食べた合計を引いた量(それ以外の人&男)

# binding.pry

    # @my_protein_difference = user.my_protein
    # @my_kcal_difference = user.my_kcal
    # @my_sugar_difference = user.my_sugar


     # if user.gender == "man"
    #   if user.exercise == "everytime"
    #     @protein_difference_everytime
    #   else
    #     @man_protein_difference_sometimes
    #   end
    #   if user.exercise == "everytime"
    #     @man_kcal_difference_everytime = 2600-kcal_amounts
    #   elsif user.exercise == "Sometimes"
    #     @man_kcal_difference_sometimes = 2400-kcal_amounts
    #   else
    #     @man_kcal_difference_not = 2200-kcal_amounts
    #   end
    #   if user.exercise == "everytime"
    #     390-sugar_amounts
    #   elsif user.exercise == "Sometimes"
    #     360-sugar_amounts
    #   else
    #     330-sugar_amounts
    #   end
    # else
    #   if user.exercise == "everytime"
    #     aptitude_protien_exercise_well-protein_amounts
    #   else
    #     50-protein_amounts
    #   end
    #   if user.exercise == "everytime" 
    #     2200-kcal_amounts
    #   elsif user.exercise == "Sometimes"
    #     2000-kcal_amounts
    #   else
    #     1800-kcal_amounts
    #   end
    #   if user.exercise == "everytime"
    #     330-sugar_amounts
    #   elsif user.exercise == "Sometimes"
    #     300-sugar_amounts
    #   else
    #     270-sugar_amounts
    #   end
    # end


  end

  def new
   @user = current_user#ログインしてるユーザーを代入
   @energy = Energy.new#Energyモデルのインスタンスを作る
  end

  def create
    @energy = current_user.energys.build(energy_params)#ストロングパラメータを渡してインスタンスを作ってインスタンス変数に代入
    #energysで複数形になってるのはUserモデルと1対多の関係にあるため
    #buildはnewと一緒の役割だけどモデルの関連付ける際はbuildを使う
    if @energy.save
      redirect_to energys_path, notice: '登録しました'
    else 
      render :new
    end
  end

  def list#(date: Date.today)
    #最初にデフォルトで今日のインスタンスを表示
    @date = Date.today
    @energys = current_user.energys.where(date: Date.today)
    #編集されたらその日付をviewに渡す
    if params[:date1]
      @date = Date.new params[:date1].to_i,params[:date2].to_i,params[:date3].to_i
      @energys = current_user.energys.where(date: @date)
    end
    #viewで入力された日付に紐づいたインスタンス
    if params["date(1i)"]
      #日付を連結してdateカラムで検索できるようにした
      @date = Date.new params["date(1i)"].to_i,params["date(2i)"].to_i,params["date(3i)"].to_i
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
      redirect_to controller: 'energys', action: 'list', date1: params[:energy]["date(1i)"],date2: params[:energy]["date(2i)"],date3: params[:energy]["date(3i)"], notice: '更新しました'
    else
      render :edit
    end
  end

  def destroy
    energy = Energy.find(params[:id])
    if energy.user_id == current_user.id#もしログインしているユーザーのidと一致したら消去
      energy.destroy
      redirect_to list_energy_path#一覧ページに戻る
    end
  end

  private
    def energy_params#ストロングパラメーターでタンパク質と糖質とカロリーと日付と食事のみを保存するようにしている
      params.require(:energy).permit(:protein, :sugar, :kcal, :meal, :date)
    end
    
end

