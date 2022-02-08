# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  prepend_before_action :authenticate_scope!, only: [:edit, :edit_password, :update, :update_password, :destroy]
  prepend_before_action :set_minimum_password_length, only: [:new, :edit, :edit_password]

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
    #BMIを計算してダイエットする必要がない人は弾く
    bmi = (@user.weight)/(@user.height/100)/(@user.height/100)
    if bmi<15
      render :exception
    end
  end

  def complete
    @user = current_user
  end

  def update_password
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      redirect_to energys_path, notice: 'パスワードを変更しました'
    else
      clean_up_passwords resource
      set_minimum_password_length
      flash.now[:alert] = "パスワードが変更できませんでした"
      render 'edit_password'
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    #プロフィール編集で入力した体重を更新または作成する
    if current_user.days.exists?(date: Date.today)
      current_user.days.find_by(date: Date.today).update(weight: params[:user][:weight])
    else
      current_user.days.create(date: Date.today, weight: params[:user][:weight])
    end
    super
  end

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

  #プロフィール編集でパスワードの要求を無しにしてパスワードの変更をする時だけパスワードを必要とする
  def update_resource(resource, params)
    if params[:password].blank? && params[:password_confirmation].blank? && params[:current_password].blank?
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
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