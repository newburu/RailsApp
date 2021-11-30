# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    @user = User.new(sign_up_params)
    super
  end

  def next
    @user = User.new(sign_up_params)
    render :new if @user.invalid?
    render :new and return if params[:back]
  end

  def confirm
    @user = User.new(sign_up_params)
    render :new and return if params[:back]
    render :next if @user.invalid?(:confirm)
    weight = @user.weight
    height = @user.height/100
    bmi = weight/height/height
    if bmi<15
    render :exception
    end
  end

  def complete
   @user = current_user
  end

  def exception
    
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  #アカウント編集後にプロフィール画面に移動する
  def after_update_path_for(resource)
    users_show_path(id: current_user.id)
  end
  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :encrypted_password, :email, :gender, :weight, :height, :exercise])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  #新規登録が終わったら完了画面に移動する
  # The path used after sign up.
  def after_sign_up_path_for(resource)
    users_sign_up_complete_path(resource)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end