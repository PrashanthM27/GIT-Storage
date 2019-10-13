public with sharing class CustomerDataController {
    public String CustomerData{set;get;}
    public CustomerDataController(ApexPages.StandardController controller){
        Account account = (Account)controller.getRecord();
        account = [Select Id,Name,Industry FROM Account WHERE Id=:account.Id];
    }
}