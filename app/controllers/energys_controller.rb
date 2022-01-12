class EnergysController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :list, :edit, :destroy, :edit, :update]
  def index
    #この形はよくない（日付を引数で渡す）
    #パラメーターで引数を渡してdateの中身を変えるようにする（デフォルトをアクションのアクションにする）
    if current_user.days.present?
      case params[:graph_sort]
        when "month"
          month_datas = current_user.days.where(date: Time.current.ago(1.month).beginning_of_day..Time.zone.now.end_of_day)
          @month_graph = month_datas.map{|n| [n.date, n.weight]}
          @graph_period = "1ヶ月間"
        when "half_year"
          half_year_datas = current_user.days.where(date: Time.current.ago(6.month).beginning_of_day..Time.zone.now.end_of_day)
          @half_year_graph = half_year_datas.map{|n| [n.date, n.weight]}
          @graph_period = "半年間"
        when "year"
          year_datas = current_user.days.where(date: Time.current.ago(1.years).beginning_of_day..Time.zone.now.end_of_day)
          @year_graph = year_datas.map{|n| [n.date, n.weight]}
          @graph_period = "1年間"
        when "all"
          all_datas = current_user.days.where("date <= ?", Time.now)
          @all_graph = all_datas.map{|n| [n.date, n.weight]}
          @graph_period = "過去全部"
        else
          week_datas = current_user.days.where(date: 1.week.ago.beginning_of_day..Time.zone.now.end_of_day)
          @week_graph = week_datas.map{|n| [n.date, n.weight]}
          @graph_period = "1週間"
      end
    else
      #体重がない時は登録した時の体重を使う
      @today_data = [[current_user.created_at.strftime('%Y/%m/%d'), current_user.weight]]
    end
    #目標体重を計算してメイン画面で表示
    @goal_weight =  (current_user.weight*0.95).round(2)
    energys = current_user.energys.where(date: Date.today)
    #メイン画面で適性を超えてるのかを計算して表示する
    @protein_amounts_sum = energys.pluck(:protein).sum
    @sugar_amounts_sum = energys.pluck(:sugar).sum
    @kcal_amounts_sum = energys.pluck(:kcal).sum
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
      #そもそも明日以降の日づを選択できないようにしたらifを１つ消せる
      if date > Date.today
        flash.now[:alert] = "明日以降の分は登録出来ません"
        render :new
      #snackのロジックを消してconfirmation_dataの後ろにかつスナックじゃなかったらにする
      elsif @energy.meal == "snack"
        @energy.save
        redirect_to energys_path, notice: '食事を登録しました'
      elsif confirmation_data
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
        # binding.pry
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
      # binding.pry
      @date = Date.new energy_params["date(1i)"].to_i, energy_params["date(2i)"].to_i, energy_params["date(3i)"].to_i
      @energy = Energy.find(params[:id])
      #&& @energy.date != @dateここがなぜ必要かを調査
      #これは変数にするcurrent_user.energys.where(date: @date, meal: energy_params[:meal]).exists?
      if current_user.energys.where(date: @date, meal: energy_params[:meal]).exists? && @energy.date != @date
        redirect_to edit_energy_path(@energy.id), alert: '既に登録されています'
      elsif current_user.energys.where(date: @date, meal: energy_params[:meal]).exists?  && @energy.meal != energy_params[:meal]
        redirect_to edit_energy_path(@energy.id), alert: '既に登録されています' 
      elsif @energy.date > Date.today
      #明日以降の日付を選べないようにする
        flash.now[:alert] = "明日以降の分は登録出来ません"
        render :edit
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
    
    def date_judgment
      #無効な日付を入力された時にエラーが出ないようにする
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