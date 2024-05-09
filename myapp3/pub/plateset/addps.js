

function typeSelection(e) {
    
    switch( e.target.value) {
  case "1":
	document.getElementById("target-layout").disabled = false;
   break;
  case "2":
	document.getElementById("target-layout").disabled = true;
	break;
  case "3":
	document.getElementById("target-layout").disabled = true;
	break;
  case "4":
	document.getElementById("target-layout").disabled = true;
	break;
  case "5":
	document.getElementById("target-layout").disabled = true;
	break;
  case "6":
	document.getElementById("target-layout").disabled = true;
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



