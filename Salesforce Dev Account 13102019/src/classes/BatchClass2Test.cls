@isTest
public class BatchClass2Test {
    static testMethod void Btest(){
    List<Lead> d=new List<Lead>();
        for(Integer i=0;i<2000;i++){
            Lead a=new Lead();
            a.FirstName='FirstName';
            a.LastName='LastName';
            a.Company='UHG'+i;
            d.add(a);
        }
            INSERT d;
          Test.startTest();
          BatchClass2 cl=new BatchClass2();
          Id batchjob=Database.executeBatch(cl);
          System.abortJob(batchjob);
          Test.stopTest();
    }
}