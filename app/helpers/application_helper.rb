module ApplicationHelper

  def devise_email_error_message
    # データベースにメールアドレスが保存されているとき
    return "" if resource.errors.empty?
    html = ""
    # エラーメッセージ用のHTMLを生成
    messages = resource.errors.full_messages_for(:email).join
    html += <<-EOF
    <div class="error_field">
      <p class="error_msg">#{messages}</p>
    </div>
    EOF
    html.html_safe
  end
  
  def devise_password_error_messages
    # パスワードのバリデーションのエラー
    return "" if resource.errors.empty?
    html = ""
    messages1 = resource.errors.full_messages_for(:password).join
    messages2 = resource.errors.full_messages_for(:password_confirmation).join
    html += <<-EOF
    <div class="error_field">
      <p class="error_msg">#{messages1}</p>
      <p class="error_msg">#{messages2}</p>
    </div>
    EOF
    html.html_safe
  end
end