class EnergysController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :list, :edit, :destroy, :edit, :update]
  def index(graph_sort: "1週間")
    from_date = params[:params_datas].present? ? params[:params_datas] : Time.current.ago(7.days).to_s
    params_datas = current_user.days.where(date: Time.parse(from_date).beginning_of_day..Time.zone.now.end_of_day)
    @weight_graphs = params_datas.map{|n| [n.date, n.weight]}
    #目標体重
    @goal_weight =  (current_user.weight*0.95).round(2)
    @goal_weight_graphs = params_datas.map{|n| [n.date, @goal_weight]}
    graph_sort = params[:graph_sort] if params[:graph_sort]
    @graph_sort = graph_sort
    #体重グラフの縦軸で使う
    @today_weight = current_user.days.last.weight.round
    #メイン画面で適性量を超えてるのかを計算
    energys = current_user.energys.where(date: Date.today)
    @protein_amounts_sums = energys.pluck(:protein).sum
    @sugar_amounts_sums = energys.pluck(:sugar).sum
    @kcal_amounts_sums = energys.pluck(:kcal).sum
  end

  def new
    @energy = Energy.new
    @date = Date.today
  end

  def create
    @energy = current_user.energys.build(energy_params)
    #登録する食事が既にDBにあるかを確認する
    confirmation_data = current_user.energys.exists?(date: energy_params[:date], meal: energy_params[:meal])
    #そもそも明日以降の日づけを選択できないようにしたらifを１つ消せる
    if Date.parse(energy_params[:date]) > Date.today
      flash.now[:alert] = "明日以降の分は登録出来ません"
      render :new
    elsif confirmation_data && @energy.meal != "snack"
      flash.now[:alert] = "既に登録されています"
      render :new
    else
      @energy.save
      redirect_to energys_path, notice: '食事を登録しました' 
    end
  end

  def list(date: Date.today)
    date = params[:date].to_date if params[:date]
    @date = date
    @energys = current_user.energys.where(date: @date).order(meal: "ASC")
    @weights = current_user.days.where(date: @date)
  end

  def edit
    @energy = Energy.find(params[:id])
  end

  def update
    @energy = Energy.find(params[:id])
    #入力された食事がDBに既にあるかをチェックする（間食は除く）
    meal_check = current_user.energys.where(date: energy_params[:date], meal: energy_params[:meal]).exists? && energy_params[:meal] != "snack"
    if Date.parse(energy_params[:date]) > Date.today
      flash.now[:alert] = "明日以降の分は選択出来ません"
      render :edit
    #&& @energy.date != @date(これがないと編集から日付を変更したら複数登録できる) @energy.meal != energy_params[:meal](これがないと同じ日にちの食事が既に登録されていてもまた登録してしまう)
    elsif meal_check && (@energy.date != Date.parse(energy_params[:date]) || @energy.meal != energy_params[:meal])
      redirect_to edit_energy_path(@energy.id), alert: '既に登録されています'
    else
      @energy.update(energy_params)
      flash[:notice] = '更新しました'
      redirect_to controller: 'energys', action: 'list', date: energy_params[:date]
    end
  end

  def record
    @energys = current_user.energys.all
  end

  def destroy
    @energy = Energy.find(params[:id])
    if @energy.user_id == current_user.id
      @energy.destroy
      flash[:notice] = "削除しました"
      redirect_to controller: 'energys', action: 'list', date: @energy.date 
    else
      render :list
    end
  end

  private
    def energy_params
      params.require(:energy).permit(:protein, :sugar, :kcal, :meal, :date)
    end
end