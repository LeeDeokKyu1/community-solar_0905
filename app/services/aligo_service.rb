class AligoService
  class << self

    TEMPLATES = {
        "TB_3688": {
            "subject_1": "인증번호",
            "message_1": "[개팔자냥팔자] 본인인증번호는 ${code}입니다."
        },
    }

    def get_list
      url = "/akv10/profile/list"
      request = call_api("post", url, {})
    end

    def template_list
      url = "/akv10/template/list/"
      call_api("post", url, {})
    end

    def send_sms(receiver, msg)
      url = "/send/"
      params = {
          key: Rails.configuration.x.aligo.apikey,
          user_id: Rails.configuration.x.aligo.userid,
          sender: Rails.configuration.x.aligo.sender,
          receiver: receiver,
          msg: msg,
      }
      result = call_sms_api("post", url, params)
    end

    def send_alimtalk(template_code, phone_number, params={})
      template = TEMPLATES[template_code]

      subject = template[:subject_1].dup
      message = template[:message_1].dup

      params.each do |k, v|
        subject.gsub!("${#{k.to_s}}", v.to_s)
        message.gsub!("${#{k.to_s}}", v.to_s)
      end

      url = "/akv10/alimtalk/send"
      params = {
          subject_1: subject,
          message_1: message,
          receiver_1: phone_number,
          tpl_code: template_code.to_s,
          failover: 'Y',
          fsubject_1: subject,
          fmessage_1: message
      }

      result = call_api("post", url, params)
    end

    def call_sms_api(method, url, body_params)
      headers = {}
      body_params.merge!({})
      result = aligo_sms_api.send(method, url, body_params, headers)
      result
    end

    def call_api(method, url, body_params)
      headers = {}
      body_params.merge!({
                             senderkey: Rails.configuration.x.aligo.sender_key,
                             userid: Rails.configuration.x.aligo.userid,
                             apikey: Rails.configuration.x.aligo.apikey,
                             sender: Rails.configuration.x.aligo.sender,
                             token: access_token
                         })
      result = aligo_api.send(method, url, body_params, headers)
      result
    end

    private
    def access_token
      return @access_token if @access_token && @expired_at.to_i > Time.now.to_i

      result = aligo_api.post '/akv10/token/create/1/h', {userid: Rails.configuration.x.aligo.userid, apikey: Rails.configuration.x.aligo.apikey}
      response = result.body

      if result.success? && response["code"] == 0
        @access_token = response['token']
        @expired_at = Time.now.since(50.minutes).to_i
      else
        Rails.logger.error response
        raise Basic::ErrorModel.new Basic::ErrorModel::ALIGO_UNAUTHORIZED
      end

      @access_token
    end

    def aligo_api
      @aligo_client ||= Faraday.new(Rails.configuration.x.aligo.host) do |conn|
        configure_connection(conn)
      end
    end

    def aligo_sms_api
      @aligo_client ||= Faraday.new(Rails.configuration.x.aligo.sms_host) do |conn|
        configure_connection(conn)
      end
    end


    def configure_connection(conn)
      conn.request :url_encoded
      conn.response :json, :content_type => /\bjson$/
      conn.use :instrumentation
      conn.adapter Faraday.default_adapter
    end

  end
end