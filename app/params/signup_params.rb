class SignupParams
  include ActiveModel::AttributeAssignment

  attr_accessor :login_provider, :social_token, :password
  attr_reader :user

  def initialize(attributes = nil)
    @login_provider = attributes[:login_provider]
    @social_token = JSON.parse(attributes[:social_token]) if attributes[:social_token]
    @password = attributes[:password]

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