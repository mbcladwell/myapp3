<!-- project#getall view template of lnserver
          Please add your license header here.
          This file is generated automatically by GNU Artanis. -->
  
<@include header.tpl %>


  <div class="container">
      <h1>All Sessions</h1>
Active sessions in <font style="color:red">red</font><br><br>

      <table id="sesstable" class="table table-striped table-bordered"><thead><tr><th>Session</th><th>Name</th><th>Group</th><th>Expires</th></tr></thead>
<tbody><%= body %></tbody>
</table>

</div>

  <script>          
$(document).ready(function() {
    $('#sesstable').DataTable({
        dom: 'lBfrtip',
        buttons: [
            'copyHtml5',
            'excelHtml5',
            'csvHtml5',
            'pdfHtml5'
        ]
   })});

</script>

<@include footer.tpl %>

