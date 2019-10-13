public class SetUpandNonSetUp {
    public static void SetUpNonSetUpObj(){
User testuser = [Select id, isActive from User where isActive=true Limit 1];
testuser.isActive = false;
update testuser;
Account co = new Account(name='Test object');
insert co;
    }
}