class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to root_path, alert: "アクセス権限がありません"
    else
      redirect_to new_user_session_path, alert: "ログインが必要です"
    end
  end

  protected

  def after_sign_in_path_for(_resource)
    root_path
  end

  def after_sign_up_path_for(_resource)
    root_path
  end

  def after_sign_out_path_for(_resource)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
