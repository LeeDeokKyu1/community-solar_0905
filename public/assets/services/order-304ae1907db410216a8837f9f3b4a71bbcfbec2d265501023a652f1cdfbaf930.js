$(function(){$(".order-btn").click(function(){const e={plan_id:$(this).data("target")};$.ajax({url:"/orders",type:"POST",dataType:"json",data:e,success:function(e){var r=e.id;location.href="/orders/"+r},error:function(e){null!=e.responseJSON&&null!=e.responseJSON.message?10002==e.responseJSON.errorCode?location.href="/login?url=/orders/plans":alert(e.responseJSON.message):alert("\ub2e4\uc2dc \uc2dc\ub3c4\ud574\uc8fc\uc138\uc694.")}})})});