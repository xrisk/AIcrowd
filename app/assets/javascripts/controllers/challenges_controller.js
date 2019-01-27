  $( function() {
    $( "#sortable" ).sortable({
      update: function(event, ui) {
                var order = $("#sortable").sortable("toArray");
                order[0] && $('#order').val(order.join(","));
            }
    });
    $( "#sortable" ).disableSelection();
    var order = $("#sortable").sortable("toArray");
    order[0] && $('#order').val(order.join(","));
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
    $('#replace-rules-button').click(function(e) {
      $(this).hide()
  },
  show: function(){
    // NATE: Apparently challenges#show is not using turbolinks
    $(document).ready(function() {
      console.info("SHOWING")
      var heading_ids = $("#description-wrapper").children().map(function() { return this.id; }).get().filter( e=>e)
      console.info(heading_ids)
      update_table_of_contents(heading_ids)
      $('body').scrollspy({target: "#table-of-contents", offset: 64})
    });
  }
});

function update_table_of_contents(heading_ids){
  var li
  var a
  var toc = $("#table-of-contents")
  var first = true
  heading_ids.forEach(id=>{
    li = document.createElement("li")
    a  = document.createElement("a")
    li.classList.add('nav-item')
    a.classList.add('nav-link')
    if(first){
      // a.classList.add('active')
      first = false
    }
    $(a).attr('href', '#' + id)
    $(a).text(_.capitalize(id).replace(/-/g, ' '))
    $(li).append(a)
    toc.append(li)
  })

}