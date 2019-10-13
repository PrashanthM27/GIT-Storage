public class ImportCSVFile{
public Contact con{set;get;}
public Blob csvData{set;get;}
public String[] csvLines{set;get;}
public String csvToString{set;get;}
public List<Contact> cont{set;get;}
public ImportCSVFile(){
con=new Contact();
cont=new List<Contact>();
}
public void getCSVFile(){
try{
csvToString=csvData.toString();
csvLines=csvToString.split('\n');
for(Integer i=1;i<csvLines.size();i++){
Contact a=new Contact();
String[] csvRecords=csvLines[i].split(',');
a.FirstName=csvRecords[1];
a.LastName=csvRecords[2];
a.Phone=csvRecords[3];
cont.add(a);
}
}
catch(Exception e)
{
ApexPages.Message errormessage=new ApexPages.Message(ApexPages.Severity.Error,'Hello {!User.FirstName}! make sure you entered CSV File');
ApexPages.addMessage(errormessage);
}
}
}