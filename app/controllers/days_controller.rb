class DaysController < ApplicationController
before_action :authenticate_user!, only: [:record,:new,:create]
  def new
    @day  = Day.new#Dayモデルのインスタンスを作る
  end

  def create
    day = current_user.days.build(day_params)
    
    if day.save
      redirect_to controller: 'energys', action: 'index', date_year: params[:day]["date(1i)"], date_month: params[:day]["date(2i)"], date_day: params[:day]["date(3i)"]
      flash[:notice] = '今日の体重を保存しました'
      # binding.pry
    else
      render :new
    end
  end

  def record
    @day = Day.find(2)
  end

  private
    def day_params
      params.require(:day).permit(:weight, :date)
    end
end
