@isTest
public class Test_AccountQuery_Controller {
   
    static testMethod void Test_Account(){
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<20;i++){
        Account ac = new Account();
        ac.Name = 'Test Prashanth Account';
        accList.add(ac);
        insert accList;
        
       Account acQuery = [SELECT Id,Name FROM Account WHERE Name='Test Prashanth Account'];
        System.assertEquals('Test Prashanth Account', acQuery.Name);
    }
}
}