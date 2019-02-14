document.addEventListener('turbolinks:load', function() {

 $("#articles").sortable({
   update: function(e,ui){
     $.ajax({
       url: $(this).data("url"),
       type: "PUT",
       data: $(this).sortable('serialize'),
       
     });

   }
 });

});
