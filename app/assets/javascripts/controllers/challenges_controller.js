  $( function() {
    $( "#sortable" ).sortable({
      update: function(event, ui) {
                var order = $("#sortable").sortable("toArray");
                $('#order').val(order.join(","));
            }
    });
    $( "#sortable" ).disableSelection();
    var order = $("#sortable").sortable("toArray");
    $('#order').val(order.join(","));
  } );


Paloma.controller('Challenges', {
  edit: function(){
    $('.active-switch').click(function(){
      var self = this;
      $('.active-switch').each(function(){
        this.checked = false;
      });
      self.checked = true;
    });
  }
});