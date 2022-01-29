class DaysController < ApplicationController
  before_action :authenticate_user!, only: [:record, :new, :create, :update, :destroy, :edit]
  include DaysHelper

  def new
    @day  = Day.new
  end

  def create
    if date_judgment
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
        flash[:notice] = '今日の体重を登録しました'
        redirect_to energys_path
      end
    else
      redirect_to new_day_path, alert: '無効な日付です'
    end
  end

  def edit
    @day = Day.find(params[:id])
  end

  def update
    @day = Day.find(params[:id])
    if date_judgment
      @date = Date.new day_params["date(1i)"].to_i, day_params["date(2i)"].to_i,day_params["date(3i)"].to_i
      if @date > Date.today
        flash.now[:alert] = "明日以降の分は登録出来ません"
        render :edit
      #編集からも同じ日のを複数登録するのを防ぐ
      elsif current_user.days.where(date: @date).count > 0 && @day.date != @date
        redirect_to edit_day_path(@day.id), alert: '既に登録されています'
      else
        @day.update(day_params)
        flash[:notice] = "更新しました"
        params_date = Date.new params[:day]["date(1i)"].to_i, params[:day]["date(2i)"].to_i, params[:day]["date(3i)"].to_i
        redirect_to controller: 'energys', action: 'list', date: params_date
        # binding.pry
      end
    else
      flash[:alert] = "選択された日付は無効な日付です"
      redirect_to edit_day_path
    end
  end

  def destroy
    @day = Day.find(params[:id])
    if @day.user_id == current_user.id
      @day.destroy
      flash[:notice] = "削除しました"
      redirect_to controller: 'energys', action: 'list', date: @day.date
    end
  end

  private
    def day_params
      params.require(:day).permit(:weight, :date)
    end

    def date_judgment
      #無効な日付を入力された時にエラーが出ないように使う
      date = day_params["date(1i)"].to_i, day_params["date(2i)"].to_i, day_params["date(3i)"].to_i
      Date.valid_date?(date[0], date[1], date[2])
    end
end