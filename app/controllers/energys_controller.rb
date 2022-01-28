class EnergysController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :list, :edit, :destroy, :edit, :update]
  def index(params_datas: current_user.days.where(date: (Time.current.ago(7.days)).beginning_of_day..Time.zone.now.end_of_day))
    if params[:graph_sort]
      params_datas = current_user.days.where(date: Time.parse(params[:graph_sort]).beginning_of_day..Time.zone.now.end_of_day)
    end
    @weight_graphs = params_datas.map{|n| [n.date, n.weight]}
    # @graph_period = "1週間" 
    #体重グラフの縦軸で使う
    @today_weight = current_user.days.find_by(date: Date.today).weight.round
    #目標体重を計算してメイン画面で表示
    @goal_weight =  (current_user.weight*0.95).round(2)
    #メイン画面で適性量を超えてるのかを計算
    energys = current_user.energys.where(date: Date.today)
    @protein_amounts_sums = energys.pluck(:protein).sum
    @sugar_amounts_sums = energys.pluck(:sugar).sum
    @kcal_amounts_sums = energys.pluck(:kcal).sum
  end

  def new
    @energy = Energy.new
  end

  def create
    if date_judgment
      @energy = current_user.energys.build(energy_params)
      date = Date.new energy_params["date(1i)"].to_i, energy_params["date(2i)"].to_i, energy_params["date(3i)"].to_i
      #登録する食事が既にDBにあるかを確認する
      confirmation_data = current_user.energys.exists?(date: date, meal: energy_params[:meal])
      #そもそも明日以降の日づけを選択できないようにしたらifを１つ消せる
      if date > Date.today
        flash.now[:alert] = "明日以降の分は登録出来ません"
        render :new
      elsif confirmation_data && @energy.meal != "snack"
        flash.now[:alert] = "既に登録されています"
        render :new
      else
        @energy.save
        redirect_to energys_path, notice: '食事を登録しました' 
      end
    else
      redirect_to new_energy_path, alert: '選択された日付は無効です'
    end
  end

  def list
    #最初にデフォルトで今日のインスタンスを表示
    binding.pry
    @date = Date.today
    list_items
    #引数の形を上手く統一できるように考えて直す
    #編集されたらviewで表示する
    if params[:date_year]
      @date = Date.new params[:date_year].to_i, params[:date_month].to_i, params[:date_day].to_i
      list_items
    #新規登録用
    elsif params["date(1i)"]
      if list_date_judgment
        @date = Date.new params["date(1i)"].to_i, params["date(2i)"].to_i, params["date(3i)"].to_i
        list_items
      else
        redirect_to list_energy_path, alert: '選択された日付は無効です'
      end
    #更新された時に使う
    elsif params[:date]
      @date =  params[:date].to_date
      list_items 
    end
  end

  def edit
    @energy = Energy.find(params[:id])
  end

  def update
  #間食を登録できるようにする
    if date_judgment
      @date = Date.new energy_params["date(1i)"].to_i, energy_params["date(2i)"].to_i, energy_params["date(3i)"].to_i
      @energy = Energy.find(params[:id])
      #&& @energy.date != @dateここがなぜ必要かを調査（これがないと同じ日の更新ができない）
      meal_check = current_user.energys.where(date: @date, meal: energy_params[:meal]).exists?
      if @date > Date.today
      #明日以降の日付を選べないようにする
        flash.now[:alert] = "明日以降の分は登録出来ません"
        render :edit
        #間食を何度でも更新できるようにした
      elsif energy_params[:meal] == "snack"
        @energy.update(energy_params)
        flash[:notice] = '更新しました'
        redirect_to controller: 'energys', action: 'list', date_year: params[:energy]["date(1i)"], date_month: params[:energy]["date(2i)"], date_day: params[:energy]["date(3i)"] 
      elsif meal_check && (@energy.date != @date or @energy.meal != energy_params[:meal])
        redirect_to edit_energy_path(@energy.id), alert: '既に登録されています'
      else
        @energy.update(energy_params)
        flash[:notice] = '更新しました'
        redirect_to controller: 'energys', action: 'list', date_year: params[:energy]["date(1i)"], date_month: params[:energy]["date(2i)"], date_day: params[:energy]["date(3i)"]
      end
    else
      redirect_to edit_energy_path, alert: '選択された日付は無効な日付です'
    end
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
    
    #無効な日付を入力された時にエラーが出ないようにする
    def date_judgment
      date = energy_params["date(1i)"].to_i, energy_params["date(2i)"].to_i, energy_params["date(3i)"].to_i
      Date.valid_date?(date[0], date[1], date[2])
    end

    def list_date_judgment
      date = params["date(1i)"].to_i, params["date(2i)"].to_i, params["date(3i)"].to_i
      Date.valid_date?(date[0], date[1], date[2])
    end

    def list_items
      @energys = current_user.energys.where(date: @date)
      @weight = current_user.days.where(date: @date)
    end

end