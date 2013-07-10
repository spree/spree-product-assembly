window.SP = SP || {};

$(function() {
  $("#searchtext").keypress(function (e) {
    if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
      window.SP.search_for_parts();
      return false;
    } else {
      return true;
    }
  });

  $("#searchtext").delayedObserver(function(element, value) {
    window.SP.search_for_parts();
  }, 0.75);

  window.SP.subscribe_product_part_links = function() {
    $("a.set_count_admin_product_part_link").click(function(){
      params = { count :  $("input", $(this).parent().parent()).val() };
      return window.SP.make_post_request($(this), params);
    });

    $("a.remove_admin_product_part_link").click(function(){
      return window.SP.make_post_request($(this), {});
    });
  };

  window.SP.make_post_request = function(link, post_params) {
    spinner = $("img.spinner", link.parent());
    spinner.show();
    $.post(link.attr("href"), post_params,
      function (data, textStatus) { spinner.hide(); },
      "script");

    return false;
  };

  window.SP.subscribe_product_part_links();
});
