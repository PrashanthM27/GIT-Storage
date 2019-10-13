global class AccountOwnerReassignment implements 
Database.Batchable<SObject>, Database.Stateful{
    
    User fromUser{get; set;}
    User toUser{get; set;}
    Double failedUpdates{get; set;}
    
    global AccountOwnerReassignment(User fromUser, User toUser){
        this.fromUser = fromUser;
        this.toUser = toUser;
        failedUpdates = 0;
    }
    
    global Database.queryLocator 
        start(Database.BatchableContext ctx){
            return Database.getQueryLocator([SELECT id, name, ownerId 
                                             FROM Account WHERE ownerId = :fromUser.id]);
        }
    
    global void Execute(Database.BatchableContext bc,List<Account> scope){
        List<Account> ac=(List<Account>)scope;
        for(integer i=0;i<ac.size();i++){
            ac[i].OwnerId=toUser.Id;
        }
        List<Database.SaveResult> res=Database.update(ac,false);
        for(Database.SaveResult sv:res){
            if(!sv.isSuccess()){
                failedUpdates++;
            }
        }
    }
    global void Finish(Database.BatchableContext bc){
        AsyncApexJob job=[Select Id,CreatedBy.Email,JobItemsProcessed,TotalJobItems,NumberofErrors from AsyncApexJob where id=:bc.getJobId()];
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        String emailMsg='Your Reassignment'+'has been processed.'+job.JobItemsProcessed;
        String[] toAddress=new String[]{job.CreatedBy.Email};
            mail.setToAddresses(toAddress);
        mail.setSubject('Assign to User');
        mail.setHtmlBody('This is Owner Assignment');
        mail.setPlainTextBody(emailMsg);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
}