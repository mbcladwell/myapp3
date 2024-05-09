


const selectedFileCookie = document.cookie
  .split('; ')
  .find(row => row.startsWith('selected-file'))
  .split('=')[1];

var toi = "Continue with import of layout from file ";
toi = toi.concat(selectedFileCookie, "?");

document.getElementById("toi").innerHTML = toi;
