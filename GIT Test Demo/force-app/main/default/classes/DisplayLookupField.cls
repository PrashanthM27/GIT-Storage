public with sharing class DisplayLookupField{
private ApexPages.StandardController stdCtl{set;get;}
public Contact cts{set;get;}
public DisplayLookupField(ApexPages.StandardController std){
stdCtl=std;
}
public void Submit(){
Contact a=(Contact)stdCtl.getRecord();
cts=[Select Id,Name from Contact where id=:a.Accountid];
}
}