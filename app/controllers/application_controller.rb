class ApplicationController < ActionController::Base
    rescue_from ActionController::RoutingError, :with => :render_404
    protect_from_forgery with: :exception
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password,:username) }
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation,:username) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation,:username) }
    end

    def render_404(exception = nil)
      if exception
          logger.info "Rendering 404: #{exception.message}"
      end
  
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
end