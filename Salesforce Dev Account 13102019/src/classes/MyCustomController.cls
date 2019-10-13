public class MyCustomController{
Public Account acc;
public MyCustomController(){
acc = [select id, Name, Phone, Industry from Account where id=: ApexPages.currentPage().getParameters().get('Id')];
}
public Account getAccount() {
return acc;
}
public PageReference saveMethod() {
update acc;
PageReference pageRef = new ApexPages.StandardController(acc).view();
return pageRef;
}
}