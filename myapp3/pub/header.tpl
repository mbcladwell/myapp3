<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
  <head>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="alternate" type="application/atom+xml" title="Atom 1.0" href="atom/1" />

 <link rel="stylesheet" type="text/css" media="screen" href="../css/navbar.css" />

 <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>

<link rel="stylesheet" type="text/css" href="../DataTables-1.10.23/css/dataTables.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="../Buttons-1.6.5/css/buttons.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="../FixedHeader-3.1.8/css/fixedHeader.bootstrap4.min.css"/>
<link rel="stylesheet" type="text/css" href="../Bootstrap-4-4.1.1/css/bootstrap.min.css"/>
 


 
 <script type="text/javascript" charset="utf8" src="../js/clipboard.min.js"></script>
 <script type="text/javascript" charset="utf8" src="../js/menufunctions.js"></script>
<script  type="text/javascript" src="../js/js.cookie.min.js"></script>     	

<script type="text/javascript" src="../jQuery-3.3.1/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="../Bootstrap-4-4.1.1/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../pdfmake-0.1.36/pdfmake.min.js"></script>
<script type="text/javascript" src="../pdfmake-0.1.36/vfs_fonts.js"></script>
<script type="text/javascript" src="../DataTables-1.10.23/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="../DataTables-1.10.23/js/dataTables.bootstrap4.min.js"></script>
<script type="text/javascript" src="../FixedHeader-3.1.8/js/dataTables.fixedHeader.min.js"></script>

<script type="text/javascript" src="../Buttons-1.6.5/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="../JSZip-2.5.0/jszip.min.js"></script>
<script type="text/javascript" src="../Buttons-1.6.5/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="../Buttons-1.6.5/js/buttons.bootstrap4.min.js"></script>





    <title>LIMS*Nucleus </title>
    

    </head>
    <body>
    
    
    <!-- Side navigation -->
   
<div class="wrapper">
  <nav id="sidebar">

 <div class="sidebar-header">
   <h3>Laboratory Automation Solutions</h3>
   <img src="../img/las-walpha.png" alt="Laboratory Automation Solutions" style="width:140px;height:100px;">
  </div>
 <ul>
   <li class="active">       
         <a href="/project/getall">Projects</a>       
   </li>
   <li class="active">    
         <a id="platesetgetps" href="#">Plate Sets for PRJ-<%= prjid %></a>       
   </li>

   <li class="active">
   	 <a id="hitlistforprj" >Hit Lists for PRJ-<%= prjid %></a>
    </li>

   <li class="active">
         <a href="/layout/getall">Plate Layouts</a>
   </li>

   
   <li class="active">
     <a href="#targetSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">Targets</a>
     <ul class="collapse list-unstyled" id="targetSubmenu">
       <li>
         <a href="/target/gettrglyt">All Target Layouts</a>
       </li>
       <li>
         <a href="/target/getall">All Targets</a>
       </li>    
     </ul>
   </li>
   <li class="active">
         <a href="../utilities/menu">Utilities</a>
       </li>      
   </li>
    
 <li class="active"> <a href="http://www.labsolns.com/software/<%= help-topic %> ">HELP</a></li>
  <li class="active"><a href="http://www.labsolns.com/software/toc">TOC</a></li>
  <li class="active"><a href="mailto:info@labsolns.com">Contact</a></li>
</ul>
  </nav>

  

<div id="content">

