class DaysController < ApplicationController
before_action :authenticate_user!, only: [:record, :new, :create, :update, :destroy, :edit]
  def new
    @day  = Day.new
  end

  def create
    date = Date.new day_params["date(1i)"].to_i, day_params["date(2i)"].to_i, day_params["date(3i)"].to_i
    @day = current_user.days.build(day_params)
    if current_user.days.exists?(date: date)
      flash.now[:alert] = "既に登録されています"
      render :new
    elsif date > Date.today
      flash.now[:alert] = "明日以降の分は登録出来ません"
      render :new
    else
      @day.save
      logger.debug  "保存したよ"
      flash[:notice] = '今日の体重を登録しました'
      redirect_to energys_path
    end
  end

  def edit
    @day = Day.find(params[:id])
  end

  def update
    @date = Date.new day_params["date(1i)"].to_i, day_params["date(2i)"].to_i, day_params["date(3i)"].to_i
    @day = Day.find(params[:id])
    #  binding.pry
    #編集からも同じ日のを複数登録するのを防ぐ
    if @date > Date.today
      flash.now[:alert] = "明日以降の分は登録出来ません"
      render :edit
    elsif current_user.days.where(date: @date).count > 0 && @day.date != @date
      redirect_to edit_day_path(@day.id), alert: '既に登録されています'
    else 
      @day.update(day_params)
      flash[:notice] = "更新しました"
      redirect_to controller: 'energys', action: 'list', date_year: params[:day]["date(1i)"], date_month: params[:day]["date(2i)"], date_day: params[:day]["date(3i)"]
    end
  end

  def destroy
   day = Day.find(params[:id])
    if day.user_id == current_user.id
      day.destroy
      flash[:notice] = "削除しました"
      redirect_to controller: 'energys', action: 'list', date: day.date
    end
  end

  private
  def day_params
    params.require(:day).permit(:weight, :date)
  end
end