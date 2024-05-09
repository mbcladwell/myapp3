
function repSelection(e) {
    
    switch( e.target.value) {
  case "1":
	document.getElementById("t2").disabled = false;
	document.getElementById("t3").disabled = false;
	document.getElementById("t4").disabled = false;
	document.getElementById("q1").innerHTML = "Quadrant 1";
	document.getElementById("q2").innerHTML = "Quadrant 2";
	document.getElementById("q3").innerHTML = "Quadrant 3";
	document.getElementById("q4").innerHTML = "Quadrant 4";
    break;
  case "2":
	document.getElementById("t2").disabled = false;
	document.getElementById("t3").disabled = true;
	document.getElementById("t4").disabled = true;
	document.getElementById("q1").innerHTML = "Quadrants 1,3";
	document.getElementById("q2").innerHTML = "Quadrants 2,4";
	document.getElementById("q3").innerHTML = "";
	document.getElementById("q4").innerHTML = "";

	break;
  case "4":
	document.getElementById("t2").disabled = true;
	document.getElementById("t3").disabled = true;
	document.getElementById("t4").disabled = true;
	document.getElementById("q1").innerHTML = "Quadrants 1,2,3,4";
	document.getElementById("q2").innerHTML = "";
	document.getElementById("q3").innerHTML = "";
	document.getElementById("q4").innerHTML = "";
	break;
	
  default:
    // code block
} 
}
