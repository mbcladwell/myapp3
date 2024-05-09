  function readSingleFile(e) {
  
      var file = e.target.files[0];
      if (!file) {
	  return;
      }
 
      var reader = new FileReader();
      reader.onload = function(e) {
	  var contents = e.target.result;
	  var numrows = lineCount(contents);
	  var format = numrows -1
	  
	       var str1 = "<div><br><label for=\"myfile\">File contents (truncated):</label></div><pre>";
         var str2 = contents.substring(0,200)
             var str3 = ". . .</pre>";
             document.getElementById("myText").innerHTML = str1.concat(str2, str3);
             document.getElementById("datatransfer").value = contents;
	     document.getElementById("hitcount").value = numrows.toString();
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
