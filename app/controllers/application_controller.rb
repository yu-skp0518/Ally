class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  #ログアウト時のパスの変更
  def after_sign_out_path_for(resource)
    if resource == :admin
      flash[:notice_log_in] = "ログアウトに成功しました"
      new_admin_session_path
    elsif
      flash[:notice_log_in] = "ログアウトに成功しました"
      root_path
    end
  end

  # ログイン後のリダイレクト先
  # def after_sign_in_path_for(resource)
  #   if current_user
  #     flash[:notice_log_in] = "ログインに成功しました"
  #     users_path
  #   else
  #     flash[:notice_log_in] = "ログインに成功しました"
  #     admin_products_path
  #   end
  # end



  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :nick_name, :is_valid])
  end
end
