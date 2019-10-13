@isTest
private class MyTestClass {

   static testMethod void test1(){

      // Retrieve two profiles, for the standard user and the system   
    
      // administrator, then populate a map with them.  
    

      Map<String,ID> profiles = new Map<String,ID>();
      List<Profile> ps = [select id, name from Profile where name = 
         'Standard User' or name = 'System Administrator'];

      for(Profile p : ps){
         profiles.put(p.name, p.id);
      }

      // Create the users to be used in this test.  
    
      // First make a new user.  
    

      User standard = new User(alias = 'standt', 
      email='prashanth.murukondaa23@gmail.com', 
      emailencodingkey='UTF-8', 
      lastname='Testing', languagelocalekey='en_US', 
      localesidkey='en_US', 
      profileid = profiles.get('Standard User'), 
      timezonesidkey='America/Los_Angeles', 
      username='prashanth.m@yahoo.com');

      insert standard;

      // Then instantiate a user from an existing profile  
    

      User admin = [SELECT Id FROM user WHERE profileid = 
                    :profiles.get('System Administrator')];

      // Create some test data for testing these two users  
    

      List<Account> accnts = new List<Account>();
      Account a1 = 
         new Account(name='Admin Account', ownerid = admin.id);
      Account a2 = 
         new Account(name='Standard Account', ownerid = standard.id);
      accnts.add(a1);
      accnts.add(a2);
      insert accnts;

      // Confirm that the standard user cannot see the admin account  
    

      system.runas(standard){
         accnts.clear();
         accnts = [select id, name from account where id = :a1.id];
         system.debug(accnts.isEmpty() + ' really'+accnts);
         System.assertEquals(accnts.isEmpty(), true);

      }
      // Confirm that the admin user can see the standard account  
    

      system.runas(admin){
         accnts.clear();
         accnts = [select id, name from account where id = :a2.id];
         System.assertEquals(accnts.isEmpty(), false);
      }
   }
}