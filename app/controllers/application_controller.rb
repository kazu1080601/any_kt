class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :prefecture, :prefecture_id, :city])
  end

  # ログイン後の画面遷移先をrootからrecommendations_pathに変更
  def after_sign_in_path_for(resource)
    # flash[:notice] = "ログインに成功しました"
    recommendations_path
  end

  # ログアウト後の画面遷移先をrootからrecommendations_pathに変更
  def after_sign_out_path_for(resource)
      # flash[:alert] = "ログアウトしました"
      recommendations_path
  end

end