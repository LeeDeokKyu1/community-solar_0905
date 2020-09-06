$(function() {
  const kakaoKey = "e5d202fca4e87a85631146db398a689a";
  const facebookAppId = "440930313176039";

  $(document).ready(function(){

    $.getScript("//developers.kakao.com/sdk/js/kakao.min.js", function() {
      Kakao.init(kakaoKey);
    });

    $.getScript("//connect.facebook.net/ko_KR/sdk.js", function() {
      FB.init({
        appId: facebookAppId,
        xfbml: true,
        cookie: false,
        version: "v6.0",
      });
      FB.AppEvents.logPageView();
    });

    $.getScript("//apis.google.com/js/platform.js", function() {
      startGoogleApp();
    });

  });

  $(".btn-container").click(function(e) {
    e.preventDefault();
    if ($("#id").val().length == 0) {
      alert("ID를 입력해주세요");
      return;
    } else if ($("#password").val().length == 0) {
      alert("패스워드를 입력해주세요.");
      return;
    }

    MiilkAuth.setIdPassword($("#id").val(), $("#password").val());
    MiilkAuth.login( function(isSuccess, message) {
      if (isSuccess) {
        var returnUrl = getReturnUrl();
        location.href = returnUrl;
      } else {
        alert(message);
      }
    });
  });

  var checkSocialAuth = null;
  var isFinished = false;
  var providerType = null;
  $(".sns-login .item").click(function(e) {
    e.preventDefault();
    const key = $(this).data("type");

    checkSocialAuth = setInterval(checkCallback, 1000);
    if (key === 'email') {
      clearInterval(checkSocialAuth);
      location.href = "/signup";
    } else if (key === 'kakao') {
      Kakao.Auth.login({
        success: function(authObj) {
          Kakao.API.request({
            url: '/v2/user/me',
            success: function(res) {
              MiilkAuth.setSocialToken('kakao', authObj, res);
              isFinished = true;
            },
            fail: function(error) {
              isFinished = true;
              clearInterval(checkSocialAuth);
            }
          });
        },
        fail: function(err) {
          isFinished = true;
          clearInterval(checkSocialAuth);
        }
      });
    } else if (key === 'naver') {
      providerType = "naver";
      var url = $("#naver_id_login_anchor")[0].href;
      window.open(url, 'naverloginpop', 'titlebar=1, resizable=1, scrollbars=yes, width=600, height=550');
    } else if (key === 'facebook') {
      FB.login(function(response) {
        if (response.status === 'connected') {
          MiilkAuth.setSocialToken('facebook', response.authResponse, response);
          isFinished = true;
        } else {
          isFinished = true;
          clearInterval(checkSocialAuth);
        }
      });
    } else if (key === 'google') {
      providerType = 'google';
      startGoogleApp();
    }
  });

  function checkCallback() {
    if (isFinished && providerType === 'google') {
      clearInterval(checkSocialAuth);
      if (googleUser != null) {
        const basicProfile = googleUser.getBasicProfile();
        const socialInfo = {
          id: basicProfile.getId(),
          name: basicProfile.getName(),
          nickname: basicProfile.getName(),
          email: basicProfile.getEmail(),
          profile_image: basicProfile.getImageUrl(),
        };
        const socialToken = googleUser.getAuthResponse();
        MiilkAuth.setSocialToken('google', socialToken, socialInfo);
        MiilkAuth.login(function(isSuccess, message) {
          if (isSuccess) {
            var returnUrl = getReturnUrl();
            location.href = returnUrl;
          } else {
            alert(message);
          }
        });
      } else {
        isFinished = false;
      }
    } else if (isFinished) {
      clearInterval(checkSocialAuth);
      MiilkAuth.login(function(isSuccess, message) {
        if (isSuccess) {
          var returnUrl = getReturnUrl();
          location.href = returnUrl;
        } else {
          alert(message);
        }
      });
    } else if (providerType === 'naver' && naver_id_login.oauthParams !== undefined) {
      clearInterval(checkSocialAuth);
      const socialInfo = {
        id: naver_id_login.getProfileData("id"),
        name: naver_id_login.getProfileData("name"),
        nickname: naver_id_login.getProfileData("nickname"),
        email: naver_id_login.getProfileData("email"),
        age: naver_id_login.getProfileData("age"),
        birthday: naver_id_login.getProfileData("birthday"),
        gender: naver_id_login.getProfileData("gender"),
        profile_image: naver_id_login.getProfileData("profile_image"),
      };
      MiilkAuth.setSocialToken('naver', naver_id_login.oauthParams, socialInfo);
      MiilkAuth.login(function(isSuccess, message) {
        if (isSuccess) {
          var returnUrl = getReturnUrl();
          location.href = returnUrl;
        } else {
          alert(message);
        }
      });
    }
  }

  $("#password").keypress(function(e) {
    if (e.keyCode === 13){
      e.preventDefault();
      if ($("#id").val().length == 0) {
        alert("ID를 입력해주세요");
        return;
      } else if ($("#password").val().length == 0) {
        alert("패스워드를 입력해주세요.");
        return;
      }

      MiilkAuth.setIdPassword($("#id").val(), $("#password").val());
      MiilkAuth.login( function(isSuccess, message) {
        if (isSuccess) {
          var returnUrl = getReturnUrl();
          location.href = returnUrl;
        } else {
          alert(message);
        }
      });
    }
  });


  let googleUser;
  var startGoogleApp = function() {
    gapi.load('auth2', function(){
      // Retrieve the singleton for the GoogleAuth library and set up the client.
      auth2 = gapi.auth2.init({
        client_id: '246544490991-crfiaqauri720n18gj1l6om2s33sppo5.apps.googleusercontent.com',
        cookiepolicy: 'single_host_origin',
        response_type: 'permission id_token token',
      });
      attachSignin(document.getElementById('g-signin2'));
    });
  };

  function attachSignin(element) {
    auth2.attachClickHandler(element, {},
        function(user) {
          googleUser = user;
          isFinished = true;
        }, function(error) {
          console.log(error);
          isFinished = true;
          clearInterval(checkSocialAuth);
          // alert(JSON.stringify(error, undefined, 2));
        });
  }

  function getReturnUrl() {
    var urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has("url")) {
      return urlParams.get("url");
    }

    return "/";
  }
});