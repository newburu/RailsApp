module DaysHelper

  def date_judgment
  #向こうな日付を入力された時にエラーが出ないように使う
  # day = Day.find(params[:id])
  date_year = day_params["date(1i)"].to_i
  date_month = day_params["date(2i)"].to_i
  date_day = day_params["date(3i)"].to_i
  if Date.valid_date?(date_year,date_month,date_day)
  flash[:alert] = "無効な日付です"
  redirect_to energys_path
  else @date = Date.new day_params["date(1i)"].to_i,day_params["date(2i)"].to_i,day_params["date(3i)"].to_i
  end
end
end