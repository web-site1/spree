class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_current_user, :force_ssl

  def set_current_user
    @current_user = current_user rescue nil
  end

  def force_ssl
    if !request.ssl? && Rails.env.production?
      redirect_to :protocol => 'https'
    end
  end

end
