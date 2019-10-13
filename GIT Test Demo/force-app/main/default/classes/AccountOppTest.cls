@isTest
private class AccountOppTest {
    static testmethod void Save(){
        Account a=new Account(Name='TestAccount');
        insert a;
        
        Opportunity op=new Opportunity();
        op.Name='TestOpportunity';
        op.AccountId=a.Id;
        op.CloseDate=System.today();
        insert op;
        
        Test.startTest();
        Database.DeleteResult result=Database.delete(a,false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size()>0);
        System.assertEquals('Cannot delete account related Opp',result.getErrors()[0].getMessage());
    }
}