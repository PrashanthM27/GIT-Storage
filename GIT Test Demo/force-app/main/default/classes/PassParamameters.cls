public with sharing class PassParamameters{
public Account c{set;get;}
public Contact con{set;get;}
public PassParamameters(){
c=new Account();
con=new Contact();
}
public void Submit(){
String name=apexpages.currentpage().getparameters().get('Name');
String industry=apexpages.currentpage().getparameters().get('Industry');
String type=apexpages.currentpage().getparameters().get('iD');
}
}