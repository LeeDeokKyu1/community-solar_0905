class ErrorModel < StandardError
  # General Error
  NOT_FOUND = {debug_message: 'not found', message: 'not found', error_code: 0, status: :not_found}
  ARGUMENT_ERROR = {debug_message: 'argument error', message: 'argument error', error_code: 1, status: :bad_request}
  FORBIDDEN = {debug_message: 'forbidden', message: 'forbidden', error_code: 2, status: :forbidden}

  # Authentication Error
  UNAUTHORIZED = {debug_message: '인증실패', message: '인증실패', error_code: 10001, status: :unauthorized, redirect: true, redirect_uri: '/login', callback: true}
  UNAUTHORIZED_WITH_EXCEPTION = {debug_message: '인증실패', message: '인증실패', error_code: 10002, status: :unauthorized, redirect: false, redirect_uri: nil, callback: false}
  DUPLICATED_USER = {debug_message: '가입 실패', message: '이미 가입된 사용자입니다.', error_code: 10003, status: :bad_request, redirect: false, redirect_uri: nil, callback: false}
  SOCIAL_ACCOUNT_NOT_FOUND = {debug_message: 'social 로그인 실패 가입 필요.', message: '가입필요', error_code: 10004, status: :not_found, redirect: false, redirect_uri: nil, callback: false}
  INVALID_SOCIAL_ACCESS_TOKEN = {debug_message: 'social 토큰 에러', message: '재로그인 해주세요', error_code: 10005, status: :unauthorized, redirect: false, redirect_uri: nil, callback: false}
  LOGIN_FAIL = {debug_message: '패스워드 틀림', message: '아이디 또는 패스워드를 확인해주세요', error_code: 10006, status: :forbidden, redirect: false, redirect_uri: nil, callback: false}

  # Service Error
  VERIFY_CODE_NOT_FOUND = {debug_message: '인증번호 확인 실패', message: '인증번호를 확인해주세요', error_code: 20000, status: :forbidden, redirect: false, redirect_uri: nil, callback: false}
  PHONE_NUMBER_NOT_FOUND = {debug_message: '전화번호 확인 실패', message: '입력하신 내용과 일치하는 정보가 없습니다.', error_code: 20001, status: :forbidden, redirect: false, redirect_uri: nil, callback: false}

  # Thrid party Error
  ALIGO_UNAUTHORIZED = {debug_message: '알리고 인증 에러', message: '일시적 오류입니다. 잠시후 이용해주세요', error_code: 30001, status: :forbidden, redirect: false, redirect_uri: nil, callback: false}

  # Order ERROR
  DAILY_EXCEED_ORDER_COUNT = {debug_message: '1일 판매 개수 초과', message: '품절되었습니다.', error_code: 40001, status: :forbidden, redirect: false, redirect_uri: nil, callback: false}
  PRODUCT_EXCEED_ORDER_COUNT = {debug_message: '전체 판매 개수 초과', message: '품절되었습니다.', error_code: 40002, status: :forbidden, redirect: false, redirect_uri: nil, callback: false}
  PRODUCT_NOT_EXIST = {debug_message: '존재하지 않는 물건', message: '품절되었습니다.', error_code: 40003, status: :forbidden, redirect: false, redirect_uri: nil, callback: false}
  MAX_QUANTITY_EXCEED = {debug_message: '인당 구매가능 갯수 초과', message: '이미 구매하셨거나 장바구니에 있습니다.', error_code: 40004, status: :forbidden, redirect: false, redirect_uri: nil, callback: false}

  # Event Error
  EVENT_NOT_FOUND = {debug_message: '이벤트가 존재하지 않습니다.', message: '이미 종료 된 이벤트 이거나 잘못된 이벤트입니다.', error_code: 50001, status: :forbidden, redirect: false, redirect_uri: nil, callback: false}
  ALREADY_EVENT_REGISTERED = {debug_message: '참가 신청이 이미 완료되었습니다.', message: '이미 신청된 이벤트입니다.', error_code: 50002, status: :forbidden, redirect: false, redirect_uri: nil, callback: false}

  attr_reader :error_type, :error_message, :error_code, :status, :redirect, :redirect_url
  def initialize(error_type, error_message=nil, error_code=nil, status=nil, redirect=nil, redirect_uri=nil, callback=nil)
    @error_type = error_type

    @error_message = error_message || error_type[:message]
    @error_code = error_code || error_type[:error_code]
    @status = status || error_type[:status]
    @redirect = redirect || error_type[:redirect] || false
    @redirect_uri = redirect_uri || error_type[:redirect_uri]
    @callback = callback || error_type[:callback] || false
  end

  def redirect?
    @redirect ||= false
    @redirect
  end

  def redirect_url(params={})
    url_param = nil
    if params.present? && @calback == true
      url_param = params.collect{|k,v| "#{k}=#{v}"}.join("&")
    end

    "#{@redirect_uri}?#{url_param}"
  end

  def to_json
    error_h = {message: @error_message, errorCode: @error_code, status: @status}

    unless Rails.env.production?
      error_h[:debugMessage] = @error_type[:debugMessage]
    end
    error_h.to_json
  end
end
