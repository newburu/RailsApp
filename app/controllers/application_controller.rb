class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    helper_method :goalweight,

    protected
        #ログインしているユーザーの目標体重を計算するメソッド
        def goalweight
            (@user.weight*0.95).round(2)
        end

        def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up,keys: [:name, :gender, :weight, :height, :exercise])
        end
end
