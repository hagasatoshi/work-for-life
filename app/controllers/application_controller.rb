class ApplicationController < ActionController::Base

  rescue_from ActionController::RoutingError, with: :redirect_404
  rescue_from Exception, with: :redirect_500

  protect_from_forgery with: :exception

  def redirect_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end
    redirect_to root_path, alert: 'お探しのページは見つかりません'
  end

  def redirect_500(exception = nil)
    if exception
      logger.info "ERROR. Rendering 500 with exception: #{exception.message}"
    end
    redirect_to root_path, alert: '問題が発生しました'
  end

  def redirect_session_invalid
    redirect_to root_path, alert: 'セッションが無効です。ホームから再実行してください' unless session[:access_token].present?
  end

  def redirect_with_error_message(message)
    session[:access_token] = nil
    redirect_to root_path, alert: message
  end
end
