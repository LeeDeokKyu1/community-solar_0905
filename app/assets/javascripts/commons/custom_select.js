$(function(){
  $(".custom-select-div").on("click", function(e){
    e.preventDefault();

    const targetId = $(this).data("targetId");
    $(`#${targetId}`).css("z-index", "9999");
    $(`#${targetId}`).focus();
  });

  $(".custom-select").on("change", function(e){
    e.preventDefault();

    $(this).css("z-index", "-1");
    const currentId = $(this).attr("id");
    const selectedValue = $(this).val();
    if (selectedValue === '직접입력') {
      $(`#${currentId}CustomTargetDiv`).hide();
      $(`#${currentId}UserCustom`).show();
      $(this).attr("size", 1);
      return;
    }

    $(`#${currentId}SelectedVal`).text($(`#${currentId} option:selected`).text());
    $(this).attr("size", 1);
  })
});
