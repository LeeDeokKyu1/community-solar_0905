$(function(){
  $(window).load(function(){
    var width = 0;
    $.each($("#mainMenuList").children(), function(idx, item) {
      width = width + $(item).outerWidth(true);
    });
    width += 10;
    const totalWidth = `${width}px`;

    $("#mainMenuList").css("width", totalWidth);
  });

  $(".menu-item").click(function(){
    if ($(this).hasClass("active")) {
      return;
    }

    const menuId = $(this).data("id");
    const currentMenu = $(this);
    $.ajax({
      type : 'get',
      url: `/articles/main?menu=${menuId}`,
      success: function(data) {
        $(".menu-item").removeClass("active");
        $(currentMenu).addClass("active");

        $("#mainMenuMore").data("id", menuId);
        $("#mainNewsList").html(data);
      }
    });
  });

  $("#mainMenuMore").click(function() {
    const menuId = $(this).data("id");
    location.href = `/articles/${menuId}/category`;
  });

  $("#topMenu").click(function(event){
    event.preventDefault();
    const isShow = $("#serviceMenu").attr("show");
    if (isShow === 'true') {
      $(".service-container").width("100vw");
      $(".service-container").height("auto");
      $("html body").css("height", "auto");
      $("html body").css("width", "100vw");
      $("html body").css("overflow", "auto");

      $("#serviceMenu").hide();
      $("#serviceMenu").attr("show", false);
    } else {
      $(".service-container").width("184.375vw");
      $(".service-container").height("100vh");
      $("html body").css("height", "100%");
      $("html body").css("width", "100%");
      $("html body").css("overflow", "hidden");

      $("#serviceMenu").show();

      $("#serviceMenu").attr("show", true);
    }
  });

  $("#topSearch").click(function(e) {
    location.href = "/search";
  });

  $("#serviceMain").click(function(e) {
    if ($(e.target).attr("id") === 'topMenu') {
      return;
    }

    const dataLink = $(e.target).data("link");
    console.log(dataLink);
    console.log(e.target);

    const isShow = $("#serviceMenu").attr("show");
    if (isShow === 'true') {
      $("body").width("100vw");
      $("body").height("auto");
      $("body").css("overflow-y", "auto");
      $("#serviceMenu").hide();
      $("#serviceMenu").attr("show", false);
    }
  })
});