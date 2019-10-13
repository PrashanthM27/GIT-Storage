public with sharing class AccountContactController{

public Account acc{set;get;}
public Contact con{set;get;}
public AccountContactController(){
String Name=ApexPages.currentPage().getParameters().get('Name');
String industry=ApexPages.currentPage().getParameters().get('Industry');
String type=ApexPages.currentPage().getParameters().get('Type');
}
}