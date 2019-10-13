public class QueueableApex2 implements Queueable{
public void Execute(QueueableContext ap){
Contact cc=new Contact();
cc.FirstName='Prashanth';
cc.LastName='Murukonda';
insert cc;
        
System.enqueueJob(new QueueableApex1());

}
}