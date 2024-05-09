  function readSingleFile(e) {
      var file = e.target.files[0];
      if (!file) {
	  return;
      }
      var reader = new FileReader();
      reader.onload = function(e) {
	  var contents = e.target.result;
	  var numrows = lineCount(contents);
	  var found_rows = numrows -1
	  var rows_needed =  document.getElementById("rows-needed").value;
	  
	  if( rows_needed == found_rows ){
	     //   let formData = new FormData();
             //   formData.append("contents", contents);
             var str1 = "<div><br><label for=\"myfile\">File contents (truncated):</label></div><pre>";
             var str2 = contents.substring(0,100)
             var str3 = ". . .</pre>";
             document.getElementById("myText").innerHTML = str1.concat(str2, str3);
             document.getElementById("datatransfer").value = contents;
	     document.getElementById("format2").value = format.toString();
               
	 // window.open( '/layout/viewlayout', "_top");
	// displayContents(contents);
    	  }else{
    	  var message1="Plate Set data import file must have ";
       	  var message2 = rows_needed.toString();
    	  var message3 = " rows of data.\n" 
    	  var message4 = found_rows.toString();    	  
    	  var message5 = "row(s) were found. Please try again.";
    	  var message6 = message1.concat(message2, message3, message4, message5);
	  window.alert(message6);
             }
      };
      reader.readAsText(file);
  }
  
  function displayContents(contents) {
      var element = document.getElementById('file-content');
      element.innerHTML = contents;
  }
 
 
 
  function lineCount( text ) {
      var nLines = 0;
      var allLines = text.split('\n');
      for( var i = 0, n = allLines.length;  i < n;  ++i ) {
           if( allLines[i].length > 0  ) {
               ++nLines;
           }
       }
       return nLines;
 }

  
  document.getElementById('myfile').addEventListener('change', readSingleFile, false);
