class User < ApplicationRecord
  enum login_provider: {email: 0, facebook: 1, kakao: 2, google: 3}
  has_secure_password validations: false
  has_many :tokens
  has_many :subscribes

  class << self
    def signup(signup_param)
      user = signup_param.user

      exist_user = self.where(login_provider: user.login_provider, login_user_id: user.login_user_id, active: true).first
      if exist_user.present?
        if exist_user.can_login?(signup_param)
          token = Token.create(user: exist_user)
          return token
        else
          raise ErrorModel.new(ErrorModel::DUPLICATED_USER)
          return
        end
      end

      if !user.email?
        social_info = SocialService.get_social_info(signup_param)
        if social_info.blank? || social_info[:login_user_id].to_i != user.login_user_id.to_i
          raise ErrorModel.new(ErrorModel::INVALID_SOCIAL_ACCESS_TOKEN)
          return
        end
      end

      User.transaction do
        user.password = signup_param.password if user.email?
        user.save
        token = Token.create(user: user)
        return token
      end
    end

    def login(login_param)
      user = self.where(login_user_id: login_param.login_user_id, active: true).first
      raise ErrorModel.new(ErrorModel::SOCIAL_ACCOUNT_NOT_FOUND) if login_param.social_login? && user.blank?
      raise ErrorModel.new(ErrorModel::LOGIN_FAIL) if user.blank?

      if !user.can_login?(login_param)
        raise ErrorModel.new(ErrorModel::LOGIN_FAIL) if !login_param.social_login?
        raise ErrorModel.new(ErrorModel::INVALID_SOCIAL_ACCESS_TOKEN) if login_param.social_login?
      end

      token = Token.create(user: user)
      token
    end
  end

  def can_login?(param)
    if email?
      return false if !self.authenticate(param.password)
    else
      social_info = SocialService.get_social_info(param)
      return false if social_info.blank? || social_info[:login_user_id].to_i != self.login_user_id.to_i
    end

    return true
  end

end
