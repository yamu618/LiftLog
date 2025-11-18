class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # SNSユーザーはcurrent_passwordなしで更新可能
  def update_resource(resource, params)
    if resource.provider.present?
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      # 通常ユーザーはDeviseの標準(current_passwordが必要)
      super
    end
  end

  def accout_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
