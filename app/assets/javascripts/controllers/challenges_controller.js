  $( function() {
    $( "#sortable" ).sortable({
      update: function(event, ui) {
                let order = $("#sortable").sortable("toArray");
                order[0] && $('#order').val(order.join(","));
            }
    });
    $( "#sortable" ).disableSelection();
    let order = $("#sortable").sortable("toArray");
    order[0] && $('#order').val(order.join(","));
  } );


Paloma.controller('Challenges', {
  edit: function(){
    $('.active-switch').click(function(){
      let self = this;
      $('.active-switch').each(function(){
        this.checked = false;
      });
      self.checked = true;
    });
    $('#replace-rules-button').click(function(e) {
      $(this).hide()
    })
  },
  show: function(){
    // NATE: Apparently challenges#show is not using turbolinks
    $(document).ready(function() {
      let heading_ids = $("#description-wrapper h1").map(function() { return this.id; }).get().filter(e=>e);
      update_table_of_contents(heading_ids);
      $('body').scrollspy({target: "#table-of-contents", offset: 64});
    });
  }
});

function update_table_of_contents(heading_ids){
  let li;
  let a;
  let toc = $("#table-of-contents");
  heading_ids.forEach(id=>{
    li = document.createElement("li");
    a  = document.createElement("a");
    li.classList.add('nav-item');
    a.classList.add('nav-link');
    $(a).attr('href', '#' + id);
    $(a).text(_.capitalize(id).replace(/-/g, ' '));
    $(li).append(a);
    toc.append(li);
  })

}
