$(document).on('turbolinks:load', function() {
  //if ($("#ul1 li:nth-child(1)").size() > 0) {
  	if ($("#ul1 li").size() > 0) {
    Poller.poll();
  }
});


window.Poller = {
  poll: function(timeout) {
    if (timeout === 0) {
      Poller.request();
    } else {
      this.pollTimeout = setTimeout(function() {
      Poller.request();
      }, timeout || 1000);
    }
  },
  clear: function() {
    return clearTimeout(this.pollTimeout);
  },
  request: function() {
    var first_id;
    first_id = $("#ul1 li:last-child").data('id');
    $.ajax({
      type: 'GET',
      url:  '/robot/index',
      dataType: 'script',
      data: {"after_id": first_id}
    });
    var element = document.getElementById("comments_box");
  }
};

