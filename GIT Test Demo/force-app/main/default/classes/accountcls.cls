public with sharing class accountcls {


public string picklist {get;set;}
public list<account> lstcon { get; set; }
public List<SelectOption> items{get; set;}

public String selectedAccount{get; set;}
public string AllAccounts {get;set;}

public accountcls(){

items = new List<SelectOption>();

items.add(new selectoption ('All Accounts','All Accounts'));
items.add(new selectoption ('MY Accounts','MY Accounts'));
items.add(new selectoption ('Last Accounts','AllOpen Accounts'));
items.add(new selectoption ('Last Accounts','AllClosed Accounts'));
items.add(new selectoption ('Last Accounts','Recently Viewed Accounts'));
items.add(new selectoption ('Last Accounts','Recently Modified Accounts'));


}


public void getContacts(){

System.debug('--selectedAccount------->'+selectedAccount);
if(picklist=='AllAccounts'){
List<account> lstcon = [Select id, name from account];

}


}
}