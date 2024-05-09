document.getElementById("desttargrep").enable=false;


function sampRepSelection(e) {
    
    switch( e.target.value) {
  case "1":
document.getElementById("desttargrep").enable=true;
document.getElementById("desttargrep").options.length = 0;	
   $('#desttargrep').append('<option value="4">4</option>');
   break;
  case "2":
document.getElementById("desttargrep").enable=true;
document.getElementById("desttargrep").options.length = 0;	
    $('#desttargrep').append('<option value="2">2</option>');
   $('#desttargrep').append('<option value="4">4</option>');
 	break;
  case "4":
document.getElementById("desttargrep").enable=true;
document.getElementById("desttargrep").options.length = 0;	
 $('#desttargrep').append('<option value="1">1</option>');
  $('#desttargrep').append('<option value="2">2</option>');	
	break;	
  default:
    // code block
} 
}



function targetSelection(e) {
switch(document.getElementById("format").value ) {
  case "96":
	document.getElementById("target-desc").text = "(only singlicates)";
   break;
 case "384":
	document.getElementById("target-desc").text = "(optional)";
   break;
 case "1536":
	document.getElementById("target-desc").text = "(optional)";
   break;


}



}



