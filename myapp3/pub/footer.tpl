</div>
</div>

	

<script>
  var str1 = "/hitlist/forprj?prjid=";
 var res1 = str1.concat( <%= prjid %>   );
 document.getElementById("hitlistforprj").href = res1;


var str3 = "/plateset/getps?id=";
 var res3 = str3.concat( <%= prjid %> );
 document.getElementById("platesetgetps").href = res3;



$(document).ready(function () {

    $('#sidebarCollapse').on('click', function () {
        $('#sidebar').toggleClass('active');
    });

});
</script>

</body>

</html>
