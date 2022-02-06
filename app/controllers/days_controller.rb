class DaysController < ApplicationController
  before_action :authenticate_user!, only: [:record, :new, :create, :update, :destroy, :edit]
  include DaysHelper

  def new
    @day  = Day.new
  end

  def create
    @day = current_user.days.build(day_params)
    if current_user.days.exists?(date: day_params[:date])
      flash.now[:alert] = "既に登録されています"
      render :new
    elsif Date.parse(day_params[:date]) > Date.today
      flash.now[:alert] = "明日以降の分は登録出来ません"
      render :new
    else
      @day.save
      flash[:notice] = '今日の体重を登録しました'
      redirect_to energys_path
    end
  end

  def edit
    @day = Day.find(params[:id])
  end

  def update
    @day = Day.find(params[:id])
    if Date.parse(day_params[:date]) > Date.today
      flash.now[:alert] = "明日以降の分は登録出来ません"
      render :edit
    #編集で同じ日の体重を更新できるようにした
    elsif current_user.days.where(date: day_params[:date]).count > 0 && @day.date != params[:day][:date].to_date
      redirect_to edit_day_path(@day.id), alert: '既に登録されています'
    else
      @day.update(day_params)
      flash[:notice] = "更新しました"
      redirect_to controller: "energys", action: "list", date: day_params[:date]
    end
  end

  def destroy
    @day = Day.find(params[:id])
    if @day.user_id == current_user.id
      @day.destroy
      flash[:notice] = "削除しました"
      redirect_to controller: "energys", action: "list", date: @day.date
    end
  end

  private
    def day_params
      params.require(:day).permit(:weight, :date)
    end
end