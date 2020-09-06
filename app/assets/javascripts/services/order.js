$(function() {
  $(".order-btn").click(function() {
    const target = $(this).data("target");
    const data = {
      plan_id: target
    };

    $.ajax({
      url: '/orders',
      type: 'POST',
      dataType: 'json',
      data: data,
      success: function(res) {
        var id = res.id;
        location.href = "/orders/" + id;
      },
      error: function(xhr, status, e) {
        if (xhr.responseJSON != null && xhr.responseJSON.message != null) {
          if (xhr.responseJSON.errorCode == 10002) {
            location.href = "/login?url=/orders/plans";
          } else {
            alert(xhr.responseJSON.message);
          }
        } else {
          alert("다시 시도해주세요.");
        }
      }
    });
  });
});