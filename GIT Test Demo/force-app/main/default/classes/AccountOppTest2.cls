@isTest
private class AccountOppTest2 {
    @isTest
    static void createAccount(){
        Account[] a=TestDataFactory.createAccountOpp(1,1);
        
        Test.startTest();
        Database.DeleteResult result=Database.delete(a[0],false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size()>0);
        System.assertEquals('You cannot delete this',result.getErrors()[0].getMessage());
    }
}