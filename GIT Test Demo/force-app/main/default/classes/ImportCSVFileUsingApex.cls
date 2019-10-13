public class ImportCSVFileUsingApex{
public List<Account> ac{set;get;}
public Blob csvFileBody{set;get;}
public String csvAsString{set;get;}
public String[] csvLines{set;get;}
public ImportCSVFileUsingApex(){
ac=new List<Account>();
csvLines=new String[]{};
}
public void importData(){
try{
csvAsString=csvFileBody.toString();
csvLines=csvAsString.split('\n');
for(Integer i=1;i<csvLines.size();i++){
Account a=new Account();
String[] csv=csvLines[i].split(',');
a.Name=csv[0];
a.Industry=csv[1];
a.Type=csv[2];
ac.add(a);
}
insert ac;
}
catch(Exception e){
ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
ApexPages.addMessage(errorMessage);
}
}
}