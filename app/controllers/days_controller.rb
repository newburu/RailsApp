class DaysController < ApplicationController
before_action :authenticate_user!, only: [:record, :new, :create, :update, :destroy, :edit]
  def new
    @day  = Day.new
  end

  def create
    day = current_user.days.build(day_params)
    date = Date.new day_params["date(1i)"].to_i, day_params["date(2i)"].to_i, day_params["date(3i)"].to_i
    confirmation_data = current_user.days.exists?(date: date)
    # binding.pry
    if confirmation_data
      flash.now[:alert] = "既に登録されています"
      render :new
    else
      day.save    
      flash[:notice] = '今日の体重を登録しました'
      redirect_to controller: 'energys', action: 'index', date_year: params[:day]["date(1i)"], date_month: params[:day]["date(2i)"], date_day: params[:day]["date(3i)"]  
    end
  end

  def record
    @days = Day.all
    @weight = current_user.days.find_by(params[:date]) 
  end

  def edit
    @day = Day.find(params[:id])
  end

  def update
    weight = Day.find(params[:id])
    if weight.update(day_params)
      flash[:notice] = "更新しました"
      redirect_to controller: 'energys', action: 'list', date_year: params[:day]["date(1i)"], date_month: params[:day]["date(2i)"], date_day: params[:day]["date(3i)"]
    else
      render :edit
    end
  end

  def destroy
   day = Day.find(params[:id])
    if day.user_id == current_user.id#もしログインしているユーザーのidと一致したら消去
      day.destroy
      redirect_to list_energy_path, notice: '削除しました'#一覧ページに戻る
    end
  end

  private
    def day_params
      params.require(:day).permit(:weigth, :date)
    end
end