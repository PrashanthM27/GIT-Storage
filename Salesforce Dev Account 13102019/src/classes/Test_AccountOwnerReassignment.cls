@isTest
public class Test_AccountOwnerReassignment {
  static testMethod void accOwnerAssign(){
    User usr = [Select Id,Name from USER WHERE NAME='PRASHANTH MURUKONDA'];
    
    List<Account> actList = new List<Account>();
    for(Integer i=0;i<10;i++){
    Account act = new Account();
    act.Name = 'Test';
    act.OwnerId = usr.Id;
    actList.add(act);
    }
    insert actList;
    
     AsyncApexJob asy = new AsyncApexJob();
     asy.CreatedBy.Email = usr.Email;
     
    AccountOwnerReassignment  assn = new AccountOwnerReassignment(usr,usr);
    assn.Execute(NULL,actList);
    assn.Finish(NULL);
  }
}