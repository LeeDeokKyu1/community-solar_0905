$(function() {
  $(".search-container #query").keyup(function(e){
    const val = $(this).val();
    if (val.length > 0) {
      $("#searchDel").show();
    } else {
      $("#searchDel").hide();
    }
  });

  $("#searchDel").click(function() {
    $(".search-container #query").val('');
    $(this).hide();
  });
});