<!-- login#auth view template of lnserver
          Please add your license header here.
          This file is generated automatically by GNU Artanis. -->

<@include loginheader.tpl %>
  <div class="container">
    <h1>Login</h1>
    
  <p style="color:red"><%= login-failed %></p>
  
  <label for="content3">Contact <a href="mailto:info@labsolns.com">Laboratory Automation Solutions</a> for options that will allow a more thorough evaluation.</label>

  <form action="/auth" method="post" >
    
    <div class="form-row">
      <label for="lnuser">Username:</label><input type="text" class="form-control"  id="lnuser" name="lnuser">
    </div>
    <div class="form-row">
      <label for="passwd">Password:</label><input type="password" class="form-control"  id="passwd" name="passwd">
    </div>
      <br>
      <div class="form-row">
	  <input type="submit"  class="btn btn-primary" value="Submit">
      </div>
      <input type="hidden" id="destination" name="destination" value=<%= destinationq %>>

  </form>


  </div>
    <@include loginfooter.tpl %>
