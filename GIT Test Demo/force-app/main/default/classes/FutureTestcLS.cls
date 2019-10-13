@isTest
public class FutureTestcLS {
    static testMethod void FutureM(){
        User u=[Select Id from User where Id =:UserInfo.getUserId()];
        System.runAs(u){
            Test.startTest();
            FutureMethodExampl.futureMethod();
            Test.stopTest();
        }
        Account a=new Account();
        a.Name='Krish';
        insert a;
    }
}