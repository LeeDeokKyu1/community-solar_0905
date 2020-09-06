$(function() {
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  $(document).ready(function() {
    MiilkAuth.signupInfo();

    if (MiilkAuth.socialInfo != null) {
      let name;
      let email;
      let accessToken;
      let loginUserId;

      accessToken = JSON.stringify(MiilkAuth.socialToken);
      if (MiilkAuth.loginProvider === 'kakao') {
        name = MiilkAuth.socialInfo.properties.nickname;
        email = MiilkAuth.socialInfo.kakao_account.email;
        loginUserId = MiilkAuth.socialInfo.id;
      } else if (MiilkAuth.loginProvider === 'naver' || MiilkAuth.loginProvider === 'google') {
        name = MiilkAuth.socialInfo.name;
        email = MiilkAuth.socialInfo.email;
        loginUserId = MiilkAuth.socialInfo.id;
      }

      $("#name").val(name);
      $("#email").val(email);
      $("#social_token").val(accessToken);
      $("#login_user_id").val(loginUserId);

      $("#login_provider").val(MiilkAuth.loginProvider);
    }
  });

  $(".terms-container .terms").click(function() {
    const box = $(this).children(".box");
    if ($(box).hasClass("active")) {
      $(box).removeClass("active");
    } else {
      $(box).addClass("active");
    }
  });

  $("#confirmBtn").click(function(e){
    e.preventDefault();
    if ($("#login_user_id").attr("verified") == true) {
      return;
    }

    const code = $("#confirm_code").val();
    if (code.length == 0) {
      $("#confirm_code").addClass("warn");
      $("#confirmResult").addClass("warn");
      $("#confirmResult").text("인증번호가 일치하지 않습니다.");
      return false;
    }

    const data = {
      target: $("#login_user_id").val(),
      code: code
    };

    $.ajax({
      url: '/users/verify',
      type: 'POST',
      dataType: 'json',
      data: data,
      success: function(resp) {
        $("#confirmResult").removeClass("warn");
        $("#confirmResult").text("인증번호이 완료되어습니다.");
        $("#login_user_id").removeClass("warn");
        $("#confirm_code").removeClass("warn");

        $("#confirmBtn").addClass("verified");
        $("#login_user_id").attr("verified", true);
        $("#login_user_id").attr("readonly", "readonly");
      },
      error: function(xhr, status, e) {
        $("#confirm_code").addClass("warn");
        $("#confirmResult").addClass("warn");
        $("#confirmResult").text("인증번호가 일치하지 않습니다.");
        // if (xhr.responseJSON != null && xhr.responseJSON.message != null) {
        //   alert(xhr.responseJSON.message);
        // } else {
        //   alert("다시 시도해주세요.");
        // }
      }
    });

  });

  $("#resendRequestBtn").click(function(e){
    e.preventDefault();

    const email = $("#login_user_id").val();
    if (!checkId()) {
      $("#login_user_id").focus();
      return false;
    }

    const data = {
      target: email
    };

    $.ajax({
      url: '/users/send_verify',
      type: 'POST',
      dataType: 'json',
      data: data,
      success: function(resp) {
        $("#confirmResult").removeClass("warn");
        $("#confirmResult").text("인증번호가 발송되었습니다.");
      },
      error: function(xhr, status, e) {
        if ((xhr.responseJSON != null) && (xhr.responseJSON.message != null)) {
          alert(xhr.responseJSON.message);
        } else {
          alert("다시 시도해주세요.");
        }
      }
    });
  });

  $("#confirmRequestBtn").click(function(e) {
    e.preventDefault();
    var $currentElement = $(this);

    const email = $("#login_user_id").val();
    if (!checkId()) {
      $("#login_user_id").focus();
      return false;
    };

    const data = {
      target: email
    };

    $.ajax({
      url: '/users/send_verify',
      type: 'POST',
      dataType: 'json',
      data: data,
      success: function(resp) {
        $currentElement.hide();
        $(".confirm-code-container").show();
      },
      error: function(xhr, status, e) {
        if ((xhr.responseJSON != null) && (xhr.responseJSON.message != null)) {
          alert(xhr.responseJSON.message);
        } else {
          alert("다시 시도해주세요.");
        }
      }
    });
  });

  $("#login_user_id").change(function(e) {
    checkId();
  });

  $("#password_confirm").change(function(e) {
    checkPassword();
  });

  $("#signupBtn").click(function(e) {
    e.preventDefault();
    if (!$("#terms").hasClass("active")) {
      alert("약관에 동의해 주세요.");
      return;
    }

    if ( $("#login_provider").val() == 'email' ) {
      const checkedId = checkId();
      const checkedPwd = checkPassword();

      if (!checkedId || !checkedId) {
        if (!checkedPwd) {
          $("#password").focus();
        } else if (!checkedId) {
          $("#login_user_id").focus();
        }
        return false;
      }

      // if ($("#login_user_id").attr("verified") != true) {
      //   $("#login_user_id").addClass("warn");
      //   $("#login_user_id").focus();
      //   return false;
      // }
    } else {
      const checkedEmail = checkEmail();
      if (!checkedEmail) {
        $("#email").focus();
        return false;
      }
    }

    const checkedName = checkName();
    const checkedPhoneNumber = true;//checkPhoneNumber();
    if (!checkedName || !checkedPhoneNumber) {

      if (!checkedName) {
        $("#name").focus();
      } else if (!checkedPhoneNumber) {
        $("#phone_number").focus();
      }

      return false;
    }

    const formData = $("#signupForm").serialize();
    $.ajax({
      url: '/users',
      type: 'POST',
      dataType: 'json',
      data: formData,
      success: function(data) {
        location.href = "/";
      },
      error: function(xhr, status, e) {
        if ((xhr.responseJSON != null) && (xhr.responseJSON.message != null)) {
          alert(xhr.responseJSON.message);
        } else {
          alert("다시 시도해주세요.");
        }
      }
    });
  });

  $("#phone_number").on("keypress input", function(e) {
    if (!((e.keyCode >=37) && (e.keyCode<=40))) {
      var inputVal = $(this).val();
      $(this).val(inputVal.replace(/[^0-9]/gi,''));
    }

  });

  function checkId() {
    var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;

    if (($("#login_user_id").val().length != 0) && regExp.test($("#login_user_id").val())) {
      $("#login_user_id").removeClass("warn");
      $("#login_user_id").siblings(".warning").removeClass("active");
    } else {
      $("#login_user_id").addClass("warn");
      $("#login_user_id").siblings(".warning").addClass("active");
      return false;
    }

    return true;
  }

  function checkPassword() {
    if (($("#password").val().length > 0) && ($("#password").val() == $("#password_confirm").val())) {
      $("#password").removeClass("warn");
      $("#password_confirm").removeClass("warn");
      $("#password_confirm").siblings(".warning").removeClass("active");
    } else {
      $("#password").addClass("warn");
      $("#password_confirm").addClass("warn");
      $("#password_confirm").siblings(".warning").addClass("active");
      return false;
    }

    return true;
  }

  function checkName() {
    if ($("#name").val().length > 0) {
      $("#name").removeClass("warn");
      $("#name").siblings(".warning").removeClass("active");
    } else {
      $("#name").addClass("warn");
      $("#name").siblings(".warning").addClass("active");
      return false;
    }

    return true;
  }

  function checkPhoneNumber() {
    if ($("#phone_number").val().length > 0) {
      $("#phone_number").removeClass("warn");
      $("#phone_number").siblings(".warning").removeClass("active");
    } else {
      $("#phone_number").addClass("warn");
      $("#phone_number").siblings(".warning").addClass("active");
      return false;
    }

    return true;
  }

  function checkEmail() {
    var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;

    if (($("#email").val().length != 0) && regExp.test($("#email").val())) {
      $("#email").removeClass("warn");
      $("#email").siblings(".warning").removeClass("active");
    } else {
      $("#email").addClass("warn");
      $("#email").siblings(".warning").addClass("active");
      return false;
    }

    return true;
  }
});