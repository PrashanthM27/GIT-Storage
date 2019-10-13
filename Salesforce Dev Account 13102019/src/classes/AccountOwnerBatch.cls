global class AccountOwnerBatch implements Database.Batchable<Sobject>{
    global Database.QueryLocator Start(Database.BatchableContext bc){
        return Database.getQueryLocator('Select Id,Name,Account.Owner,CreatedName from Account where LastModifiedDate<Last_N_Days:180');
    }
    global void Execute(Database.BatchableContext bc,List<Account> scope){
        List<String> names=new List<String>();
        for(Account a:scope){
            names.add(a.Name);
        List<Messaging.SingleEmailMessage> emails=new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
        String[] address=new String[]{'prashanthmpsfdc@gmail.com'};
            mail.setToAddresses(address);
            mail.setPlainTextBody('Hello'+a.OwnerId+'This Account'+names+'has not been modified');
            mail.setSubject('Mail to Account Owner');
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });     
        }
    }
    global void Finish(Database.BatchableContext bc){
        
    }
}