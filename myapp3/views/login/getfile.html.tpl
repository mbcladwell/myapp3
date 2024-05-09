<!-- form#getfile view template of postest
          Please add your license header here.
          This file is generated automatically by GNU Artanis. -->

<html>
  <head>
    <title><%= (current-appname) %>
    </title>
    

  </head>
  <body>
    <h1>form#getfile</h1>
    <p>Rendered from app/views/form/getfile.html.tpl.</p>



  <form action="/upload" method="post" enctype="multipart/form-data" class="form-example">
    <label for="myfile">Choose a file:</label>
<input type="file"
       id="myfile" name="myfile"
       accept=".txt">
    <input type="submit" value="Submit">
</form>
  </body>



  
</html>
