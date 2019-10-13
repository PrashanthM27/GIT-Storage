@isTest
public class Test_TaskCanbeCreatedforSoldtoOnly {
    static testMethod void taskCreation(){
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.Type = 'bill to Customer';
        insert ac;

        Task t = new Task();
        t.whatId = ac.Id;
        insert t;
    }
}