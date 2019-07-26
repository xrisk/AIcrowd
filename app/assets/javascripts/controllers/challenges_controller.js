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
      let escapeIds = function() {
          let x = this.id;
          // Remove special chars from the ID, to make sure scrollspy does not break.
          this.id = x.replace(/[^a-z0-9_-]/gi, '');
          // But return the original for displaying
          return x;
      }
    // NATE: Apparently challenges#show is not using turbolinks
    $(document).ready(function() {
      let heading_ids = $("#description-wrapper h1").map(escapeIds).get().filter(e=>e);
      update_table_of_contents(heading_ids);
    });
  }
});

function update_table_of_contents(heading_ids){
  let li;
  let a;
  let toc = $("#table-of-contents");
  let done = 0;
  heading_ids.forEach(id=>{
      li = document.createElement("li");
      a  = document.createElement("a");
      li.classList.add('nav-item');
      a.classList.add('nav-link');
      $(a).attr('href', '#' + id.replace(/[^a-z0-9_-]/gi, ''));
      $(a).text(_.capitalize(id).replace(/-/g, ' '));
      $(li).append(a);
      toc.append(li);
      // Attach ScrollSpy only after the TOC has been generated.
      done += 1;
      if(done === heading_ids.length) {
        $('body').scrollspy({target: "#table-of-contents", offset: 64});
      }
  });
}