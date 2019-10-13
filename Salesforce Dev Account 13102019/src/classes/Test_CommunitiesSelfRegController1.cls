@isTest
public class Test_CommunitiesSelfRegController1 {
    static testMethod void selfRegCont(){
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        System.runAs(thisUser) {
           Profile p = [SELECT Id FROM Profile WHERE UserType='Standard User']; 
            UserRole ur = new UserRole(Name = 'CEO');
            insert ur;
            
            String orgId = UserInfo.getOrganizationId();
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
            String uniqueName = orgId + dateString + randomInt;
            
            User u = new User(Alias = 'standt', Email=uniqueName+'@testorg.com', 
                              EmailEncodingKey='UTF-8',FirstName = 'Data', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = ur.id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName+'@testorg.com');
            insert u;
            Account ac = new Account();
            ac.Name = 'Test Account';
            insert ac;

            CommunitiesSelfRegController1 contr = new CommunitiesSelfRegController1();
            contr.email = u.Email;
            contr.firstName = u.FirstName;
            contr.lastName = u.LastName;
            contr.communityNickname = 'TestCommunity';
            contr.password = 'Hello1234';
            contr.confirmPassword = 'Hello1234';            
            contr.isValidPassword();
            contr.registerUser();
        }
    }
}