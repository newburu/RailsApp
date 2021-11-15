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
    #render :new if @user.invalid?
    super
    #redirect_to  controller: :days, action: :index
  end

  def next
    @user = User.new(sign_up_params)
    render :new if @user.invalid?
    #render :new and return if params[:back]
    session["devise.regist_data"] = {user: @user.attributes}
    session["devise.regist_data"][:user]["password"] = params[:user][:password]
  end

  def confirm
    @user = User.new(sign_up_params)
    render :new if @user.invalid?(:confirm)
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
  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :encrypted_password, :email, :gender, :weight, :height, :exercise])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  #新規登録が終わったらリダイレクトするviewを設定している
  # The path used after sign up.
  def after_sign_up_path_for(resource)
    days_home_path(resource)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end