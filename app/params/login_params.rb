class LoginParams
  include ActiveModel::AttributeAssignment

  attr_accessor :login_provider, :login_user_id, :social_token, :password
  def initialize(attributes = nil)
    @login_provider = attributes[:login_provider]
    @login_user_id = attributes[:login_user_id]
    @password = attributes[:password]
    @social_token = attributes[:social_token]

    if attributes.respond_to?(:permit)
      @user = User.new(attributes.permit(*User.attribute_names))
    else
      @user = User.new(attributes.slice(*User.attribute_names))
    end
  end

  def social_login?
    @login_provider != "email"
  end

  def access_token
    if social_login? && @social_token.present?
      @social_token["access_token"] || @social_token[:access_token] ||
          @social_token["accessToken"] || @social_token[:accessToken] ||
          @social_token["id_token"] || @social_token[:id_token]
    else
      return nil
    end
  end
end