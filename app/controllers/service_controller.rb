class ServiceController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate!
  before_action :require_user

  rescue_from ErrorModel do |err|
    Rails.logger.error err.error_type
    if err.redirect?
      redirect_to err.redirect_url({redirect: request.env["REQUEST_URI"]})
    else
      respond_to do |format|
        format.html { render json: err.to_json, status: err.status}
        format.json { render json: err.to_json, status: err.status}
      end
    end
  end

  def index
  end

  def terms
  end

  def privacy
  end

  private
  def authenticate!
    access_token = cookies[:authorization] || request.env['HTTP_AUTHORIZATION']

    @token = Token.includes(:user).where(access_token: access_token, users: {active: true}).first
    @current_user = @token&.user
    @has_email = cookies[:emid].to_s.present?
  end

  def current_user
    @current_user
  end

  def require_user
    redirect_to "/login?url=#{request.env["REQUEST_URI"]}" if current_user.blank?
  end

  def require_user_with_exception
    raise ErrorModel.new(ErrorModel::UNAUTHORIZED_WITH_EXCEPTION) if current_user.blank?
  end
end