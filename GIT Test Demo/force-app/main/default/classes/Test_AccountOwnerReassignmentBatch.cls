@isTest
public class Test_AccountOwnerReassignmentBatch {
   public static testMethod void Save(){
       
       // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='prashanthmpsfdc@gmail.com');

        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        
              
    
       AccountOwnerReassignment assn = new AccountOwnerReassignment(u,u);
       Database.executeBatch(assn);
        }
    }
}