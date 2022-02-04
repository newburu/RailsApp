class EnergysController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :list, :edit, :destroy, :edit, :update]
  def index(graph_sort: "1週間")
    from_date = params[:params_datas].present? ? params[:params_datas] : Time.current.ago(7.days).to_s
    params_datas = current_user.days.where(date: Time.parse(from_date).beginning_of_day..Time.zone.now.end_of_day)
    @weight_graphs = params_datas.map{|n| [n.date, n.weight]}
    graph_sort = params[:graph_sort] if params[:graph_sort]
    @graph_sort = graph_sort
    #体重グラフの縦軸で使う
    @today_weight = current_user.days.last.weight.round
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

  def list(date: Date.today)
    #viewから選択された日付を取得するのと編集された時の日付と削除された時の日付を同じ形のパラメーターとして持ってきてパラメーターに日付がない時はデフォルトで今日の日付を使う
    #最初にデフォルトで今日のインスタンスを表示
    #引数の形を上手く統一できるように考えて直す
    if params["date(1i)"]
      #list_date_judgmentなぜかメソッドを作ってそれをここに入れてもviewの日付が全部同じデフォルト値になる
      #２重ifをうまくまとめたい今の所elseのところをまとめたいparams["date(1i)"]の時で勝つelseの時
      if Date.valid_date?(params["date(1i)"].to_i,params["date(2i)"].to_i,params["date(3i)"].to_i)
        date = Date.new params["date(1i)"].to_i, params["date(2i)"].to_i, params["date(3i)"].to_i
      else
        redirect_to list_energy_path, alert: '選択された日付は無効です'
      end
    end
    @date = date
    @energys = current_user.energys.where(date: @date)
    @weights = current_user.days.where(date: @date)
  end

  def edit
    @energy = Energy.find(params[:id])
  end

  def update
    if date_judgment
      @date = Date.new energy_params["date(1i)"].to_i, energy_params["date(2i)"].to_i, energy_params["date(3i)"].to_i
      @energy = Energy.find(params[:id])
      #&& @energy.date != @dateここがなぜ必要かを調査（これがないと同じ日の更新ができない）
      meal_check = current_user.energys.where(date: @date, meal: energy_params[:meal]).exists?
      if @date > Date.today
      #明日以降の日付を選べないようにする
        flash.now[:alert] = "明日以降の分は登録出来ません"#viewで制御する
        render :edit
      #間食を何度でも更新できるようにした
      elsif energy_params[:meal] == "snack"
        @energy.update(energy_params)
        flash[:notice] = '更新しました'
        params_date = Date.new params[:energy]["date(1i)"].to_i, params[:energy]["date(2i)"].to_i, params[:energy]["date(3i)"].to_i
        redirect_to controller: 'energys', action: 'list', date: params_date
      elsif meal_check && (@energy.date != @date or @energy.meal != energy_params[:meal])
        redirect_to edit_energy_path(@energy.id), alert: '既に登録されています'
      else
        @energy.update(energy_params)
        flash[:notice] = '更新しました'
        redirect_to controller: 'energys', action: 'list', "date(1i)": params[:energy]["date(1i)"], "date(2i)": params[:energy]["date(2i)"], "date(3i)": params[:energy]["date(3i)"]
      end
    else
      redirect_to edit_energy_path, alert: '選択された日付は無効な日付です'#viewで制御する
      #選択肢をコントローラーで生成してインスタンス変数としてviewに渡す可能性でもある
    end
  end

  def destroy
    @energy = Energy.find(params[:id])
    if @energy.user_id == current_user.id
      @energy.destroy
      flash[:notice] = "削除しました"
      redirect_to controller: 'energys', action: 'list', "date(1i)": @energy.date.year, "date(2i)": @energy.date.month, "date(3i)": @energy.date.day 
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
end