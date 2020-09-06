module Service
  class UsersController < ServiceController
    skip_before_action :verify_authenticity_token, only: [:login, :create, :signup, :login_user, :landing_signup]
    skip_before_action :require_user, only: [:login, :create, :signup, :login_user, :landing_signup]

    def login
    end

    def login_user
      login_param = LoginParams.new(params)
      token = User.login(login_param)
      cookies[:authorization] = token.access_token
      render json: {head: :ok}
    end

    def landing_signup
    end

    def signup
      @login_provider = params[:login_provider] || 'email'
    end

    def create
      signup_param = SignupParams.new(params)
      token = User.signup(signup_param)
      cookies[:authorization] = token.access_token
      render json: {head: :ok}
    end

    def me
    end

  end
end