class SocialService
	class << self
		def get_social_info(attributes)
			return nil if attributes.access_token.blank?

			case attributes.login_provider
			when 'facebook'
				facebook_me(attributes.access_token)
			when 'kakao'
				kakao_me(attributes.access_token)
			when 'google'
				google_me(attributes.access_token)
			when 'naver'
				naver_me(attributes.access_token)
			else
				nil
			end
		end

		private
		def naver_api
			@naver_client ||= Faraday.new(Rails.configuration.x.naver_api_url) do |conn|
				configure_connection(conn)
			end
		end

		def facebook_api
			@facebook_client ||= Faraday.new(Rails.configuration.x.facebook_api_url) do |conn|
				configure_connection(conn)
			end
		end

		def kakao_api
			@kakao_client ||= Faraday.new(Rails.configuration.x.kakao_api_url) do |conn|
				configure_connection(conn)
			end
		end

		def google_api
			@google_client ||= Faraday.new(Rails.configuration.x.google_api_url) do |conn|
				configure_connection(conn)
			end
		end

		def configure_connection(conn)
			conn.request :url_encoded
			conn.response :json, :content_type => /\bjson$/
			conn.use :instrumentation
			conn.adapter Faraday.default_adapter
		end

		def naver_me(access_token)
			result = naver_api.get '/v1/nid/me', {}, {Authorization: "Bearer #{access_token}"}

			if result.success?
				body = result.body
				{
						login_provider: 'naver',
						login_user_id: body["id"],
						nickname: body["name"],
						notification_email: body["email"]
				}
			else
				nil
			end
		end

		def facebook_me(access_token)
			result = facebook_api.get '/me', { fields: 'id,name,email,picture.type(large)', access_token: access_token }, { Authorization: "OAuth #{access_token}" }

			if result.success?
				{
						login_provider: 'facebook',
						login_user_id: result.body["id"],
						nickname: result.body["name"],
						notification_email: result.body["email"],
						profile_image_url: result.body.dig("picture", "data", "url")
				}
			else
				nil
			end
		end

		def kakao_me(access_token)
			result = kakao_api.get '/v2/user/me', {}, { Authorization: "Bearer #{access_token}" }
			if result.success?
				{
						login_provider: 'kakao',
						login_user_id: result.body["id"],
						nickname: result.body.dig("properties", "nickname"),
						profile_image_url: result.body.dig("properties", "profile_image")
				}
			else
				nil
			end
		end

		def google_me(access_token)
			result = google_api.get '/tokeninfo', {id_token: access_token}, {}
			if result.success?
				{
						login_provider: 'google',
						login_user_id: result.body["sub"],
						nickname: result.body["name"],
						profile_image_url: result.body["picture"]
				}
			else
				nil
			end
		end
	end
end