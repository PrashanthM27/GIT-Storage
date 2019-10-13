@isTest
public class QueueableTest{
public static testMethod void QueueTest(){
Test.StartTest();
System.enqueueJob(new QueueableApex1());
Test.StopTest();
Account a=[Select Id,Name,Industry from Account where Name='Prathyusha'];
System.assertEquals('Prathyusha',a.Name);

}
}