public with sharing class apextojavascript11 {
public string calltoclose {get;set;}
public void close(){
calltoclose = '<script> closeWin(); </script>';
}
}