class DaysController < ApplicationController
before_action :authenticate_user!, only: [:record,:new,:create]
  def new
    @day  = Day.new
  end

  def create
    @day = current_user.days.build(day_params)
    date = Date.new day_params["date(1i)"].to_i, day_params["date(2i)"].to_i, day_params["date(3i)"].to_i
    confirmation_data = current_user.days.exists?(date: date)
    if confirmation_data
      flash.now[:alert] = "既に登録されています"
      render :new
    else
      @day.save
      flash[:notice] = '今日の体重を登録しました'
      redirect_to controller: 'energys', action: 'index', date_year: params[:day]["date(1i)"], date_month: params[:day]["date(2i)"], date_day: params[:day]["date(3i)"]  
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
