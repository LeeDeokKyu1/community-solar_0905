const MiilkAuth = {
  loginProvider: null,
  loginUserId: null,
  password: null,
  socialToken: null,
  socialInfo: null,
  signupInfo: function () {
    var loginProvider = localStorage.getItem("loginProvider");
    var socialToken = localStorage.getItem("socialToken");
    var socialInfo = localStorage.getItem("socialInfo");
    if (loginProvider !== null && loginProvider.length !== 0 && socialToken !== null && socialToken.length !== 0) {
      this.loginProvider = loginProvider;
      this.socialToken = JSON.parse(socialToken);
      if (socialInfo.length !== 0) {
        this.socialInfo = JSON.parse(socialInfo);
      }
    }

    localStorage.removeItem("loginProvider");
    localStorage.removeItem("socialToken");
    localStorage.removeItem("socialInfo");
  },
  login: function (callback) {
    const data = {
      login_provider: this.loginProvider,
      login_user_id: this.loginUserId,
      password: this.password,
      social_token: this.socialToken
    };

    var socialInfo = this.socialInfo;

    $.ajax({
      type: "POST",
      url: '/login',
      dataType: 'json',
      data: data,
      success: function (res) {
        callback(true, null);
      },
      error: function (res) {
        if (res.responseJSON.errorCode === 10004) {
          localStorage.setItem("loginProvider", data.login_provider);
          localStorage.setItem("socialToken", JSON.stringify(data.social_token));
          localStorage.setItem("socialInfo", JSON.stringify(socialInfo));
          location.href = `/signup?login_provider=${data.login_provider}`;
        }  else if (res.responseJSON.message != null) {
          callback(false, res.responseJSON.message);
        } else {
          callback(false, "다시시도해주세요.");
        }
      }
    });
  },
  setIdPassword: function (id, password) {
    this.loginProvider = 'email';
    this.loginUserId = id;
    this.password = password;
  },
  setSocialToken: function (loginProvider, token, socialInfo) {
    this.loginProvider = loginProvider;
    this.socialToken = token;
    this.socialInfo = socialInfo;
    this.loginUserId = socialInfo.id;
  }
}
