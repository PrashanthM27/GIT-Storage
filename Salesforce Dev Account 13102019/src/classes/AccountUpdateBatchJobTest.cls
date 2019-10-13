@isTest 
public class AccountUpdateBatchJobTest 
{
    static testMethod void testMethod1() 
    {
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <200;i++)
        {
            Account acc = new Account();
            acc.Name ='Name'+i;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();

            AccountUpdateBatchJob obj = new AccountUpdateBatchJob();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}