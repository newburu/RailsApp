class DaysController < ApplicationController
before_action :authenticate_user!, only: [:record,:new,:create]
  def new
    # binding.pry
    @user = current_user
    @day  = Day.new#Dayモデルのインスタンスを作る
  end

  def create
    @day = current_user.days.build(day_params)
    
    if @day.save
     redirect_to energys_path, notice: '今日の体重を保存しました'
    else
     render :new
    end
    #binding.pry
  end

  def record
    @user = current_user
    @day = Day.find(2)
  end

  private
    def day_params
      params.require(:day).permit(:weight)
    end
end
