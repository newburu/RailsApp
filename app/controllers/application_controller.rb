class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :goalweight

  protected
    #ログインしているユーザーの目標体重を計算するメソッド
    def goalweight
      (@user.weight*0.95).round(2)
    end

    #ログイン後にメイン画面に移動する
    def after_sign_in_path_for(resource)
      energys_path(resource)
    end

    #新規登録時のストロングパラメータ
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up,keys: [:name, :gender, :weight, :height, :exercise])
      #情報更新時にストロングパラメータ
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :gender, :weight, :height, :exercise])
    end
end
