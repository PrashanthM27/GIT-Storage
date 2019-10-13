public class Account_Controller{
public void accRecord(){
Account IT = new Account();
String integrationtransactionId= '0016F00001y5mQW';
List<String> fields = new List<String>(Account.SObjectType.getDescribe().fields.getMap().keySet());
String soql='';
soql=soql+' select ';
soql=soql+String.join(fields, ',');
System.debug('checking'+soql);
soql=soql+' from Account where id=:integrationtransactionid';
System.debug('soqq'+soql);
IT=database.query(soql);
System.debug('itt'+IT);
 

}

}